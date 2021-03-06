#!/usr/bin/env python
#
# Copyright 2017 Fausto Fusaro - Injenia Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from flask import Flask
from flask import json, render_template
from google.cloud import storage
from google.cloud.storage import Blob
from PIL import Image, ImageFilter, ImageEnhance, ImageMath
import os
import syslog
import random
import string
import time
import mysql.connector
import requests

__author__ = "Injenia Srl"
__credits__ = "Fausto Fusaro"
__version__ = "0.3.0b"
__email__ = "fausto.fusaro@injenia.it"

config = {
    'user': os.environ['SQL_USERNAME'],
    'password': os.environ['SQL_PASSWORD'],
    'host': '127.0.0.1',
    'database': 'inpho',
}

destination_bucket = os.environ['DESTINATION_BUCKET']

# a bit of prints for debug purpose
print("config: %s" % config)
print("destination_bucket: %s" % destination_bucket)
syslog.syslog("INTECH worker - config: %s" % config)
syslog.syslog("INTECH worker - destination_bucket: %s" % destination_bucket)

app = Flask(__name__)


def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    """
    Create a random string
    :param size: length of the generated string
    :param chars: set of chars to pick from
    :return: a new random string
    """
    return ''.join(random.choice(chars) for _ in range(size))


def am_i_ok():
    """
    A dummy check of instance health. If there is a file alarm.txt the instance is unhealthy!
    :return: a boolean True if it is ok, False otherwise
    """
    if os.path.isfile("alarm.txt"):
        return False
    return True


@app.route("/")
def do_job_without_fails():
    return manipulate(False)


@app.route("/withfails")
def do_job_with_fails():
    return manipulate(True)


def manipulate(with_fails=False):

    # initialize execution timer
    start_time = time.time()

    response_obj = None

    # instance metadata
    worker = 'someone'
    job_id = None
    try:
        req = requests.get(
            "http://metadata/computeMetadata/v1/instance/name",
            headers={'Metadata-Flavor': 'Google'})
        if req.status_code < 299:
            worker = req.text
        else:
            print("Worker name unrecognized")
            syslog.syslog("Worker name unrecognized")
    except Exception as exc:
        print("Worker name unrecognized. %s" % exc)
        syslog.syslog("Worker name unrecognized. %s" % exc)
        worker = 'unrecognized'

    try:
        # MySQL initialization
        cnx = mysql.connector.connect(**config)
        cursor = cnx.cursor()

        # seek my job
        job_etag = id_generator()
        mysql_set_job = "UPDATE jobs SET status=2, worker=%s, etag=%s, id = @selected_job := id " \
                        "WHERE status in (0, 3) LIMIT 1"
        cursor.execute(mysql_set_job, (worker, job_etag))
        cnx.commit()

        mysql_get_job = "SELECT id, image_bucket, image_path, fail, status, worker, etag " \
                        "FROM jobs WHERE id = @selected_job"
        cursor.execute(mysql_get_job)

        job_bucket = None
        job_image = None
        for (jid, image_bucket, image_path, fail, status, worker, etag) in cursor:
            print("DEBUG: jid=%s, image_bucket=%s, fail=%s, image_path=%s, status=%s, worker=%s, etag=%s" %
                  (jid, image_bucket, image_path, fail, status, worker, etag))
            if etag == job_etag:
                # I have a job!
                job_id = jid
                job_bucket = image_bucket
                job_image = image_path

                print('Ready to execute the job %s: %s/%s' % (job_id, job_bucket, job_image))
                syslog.syslog('INTECH worker - Ready to execute the job %s: %s/%s' %
                              (job_id, job_bucket, job_image))
            else:
                # I don't have a job :(
                print('All jobs are completed')
                syslog.syslog('INTECH worker - All jobs are completed')
            break

        try:
            # closing connections
            cursor.close()
            cnx.close()
        except:
            syslog.syslog('INTECH worker - Fail when closing connection')
            pass

        if job_id is None:
            print('There aren\'t jobs. Closing the communication :( bye')
            syslog.syslog('INTECH worker - There aren\'t jobs. Closing the communication :( bye')
            response_obj = render_template('land.html', result_class="error", message="I\'m jobless... I have no tasks",
                                           time="%.2f" % (time.time() - start_time), job_id="", worker=worker,
                                           etag="", output_path=""), 404
            return response_obj
        
        if with_fails and fail:
            # write a file for the health check
            syslog.syslog('INTECH worker - Ops, I found a simulated error. I create file alarm.txt ')
            with open("alarm.txt", 'w') as file_obj:
                file_obj.write("this is an error!")
            
            raise Exception('Simulated error requested! I will fail...')

        # initialize GCS client and source image
        client = storage.Client()
        source_bucket = client.get_bucket(job_bucket)
        blob = Blob(job_image, source_bucket)
        dl_file_name = "dl_%s.jpg" % job_etag
        with open(dl_file_name, 'wb') as file_obj:
            blob.download_to_file(file_obj)

        # process source image
        im1 = Image.open(dl_file_name)
        im2 = im1.filter(ImageFilter.EDGE_ENHANCE_MORE)
        enhancer = ImageEnhance.Sharpness(im2)
        im3 = enhancer.enhance(2.0)
        out = ImageMath.eval("convert(a, 'L')", a=im3)

        # save new image locally
        res_file_name = "%s_%s.png" % (job_etag, job_image.rsplit('/', 1)[-1])
        out.save(res_file_name)

        # upload image to my GCS bucket
        dest_bucket = client.get_bucket(destination_bucket)
        blob = Blob("results/%s" % res_file_name, dest_bucket)
        with open(res_file_name, 'rb') as my_file:
            blob.upload_from_file(my_file)

        # cleaning stuffs
        os.remove(dl_file_name)
        os.remove(res_file_name)

        response_obj = render_template('land.html', result_class="success", message="operation succeeded",
                                       time="%.2f" % (time.time() - start_time), job_id=job_id, worker=worker,
                                       etag=etag, output_path="%s/%s" % (job_bucket, job_image)), 200
    except Exception as exc:
        print("Runtime error: %s" % exc)
        syslog.syslog("INTECH worker - Runtime error: %s" % exc)

        response_obj = render_template('land.html', result_class="error", message="error occurred",
                                       time="%.2f" % (time.time() - start_time), job_id=job_id, worker=worker,
                                       etag="", output_path=""), 500

    return response_obj


@app.route("/healthcheck")
def health_check():
    response_obj = None

    if am_i_ok():
        response_obj = app.response_class(
            response=json.dumps({
                'status': 'ok'
            }),
            status=200,
            mimetype='application/json'
        )
    else:
        response_obj = app.response_class(
            response=json.dumps({
                'status': 'something wrong!'
            }),
            status=500,
            mimetype='application/json'
        )

    return response_obj


@app.route("/resetstatus")
def reset_status():
    response_obj = None

    if not am_i_ok():
        os.remove("alarm.txt")
        response_obj = app.response_class(
            response=json.dumps({
                'status': 'ok'
            }),
            status=200,
            mimetype='application/json'
        )

    return response_obj


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, threaded=True)
