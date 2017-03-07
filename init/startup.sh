#!/bin/bash

sudo su

# env variables
cd /usr/local/intech/init/
chmod +x env.sh
rm -f config
./env.sh
source config

# start Cloud SQL proxy
cd /usr/local/cloud_sql/
sudo ./cloud_sql_proxy -instances=$SQL_CONNECTION_NAME=tcp:3306 &

# run web app
cd /usr/local/intech
source intech/bin/activate
python run.py &