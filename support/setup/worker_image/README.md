# Google Cloud Console Project Setup

## Requirements

Before starting you need:
1. a G Suite user account, with Google Developer Console enabled
1. an empty Google Cloud Console project associated with a valid billing account
1. if you want to use your machine, a command line interface with [gcloud](https://cloud.google.com/sdk/downloads) installed

## Configure gcloud CLI

This is necessary only if you want to use your laptop shell. Once installed, gcloud needs to be configured with the right user and the working project.
Please run this command and follow its steps; when asked, select the project you're going to use with this lab.

```bash
gcloud init
```

## Google Cloud Console

Go to the [Google Cloud Console](https://cloud.google.com/consoele) and select your project. This is your working console, where all the magic happens.

Then, click on the button "Google Cloud Shell" in the up-right side of the page. You will see an awesome browser based shell. 

Please ensure that you copy/download this code in the location you choose as your favourite shell.

**NOTICE**: this codelab will use 2 different GCC projects, one project for common assets (Assets Project) and another one that contains all the workers (Workers Project).

## Assets project

This project contains all useful assets. The Workers Project needs these stuffs to work as expected.

### Google Cloud Storage

Upload the whole content in the folder /support/public into a your bucket (this project uses the name "intech"). Then share publicly these items:

* background_fhd.jpg
* schema_dump_v2.gz
* startup.sh
* photos/*.jpg

Furthermore add to the bucket the permission Reader for the special usel "allUsers".

### Worker image

The purpose is to create a base image that can be used to generate new workers within a resilient group of VMs.
First, create a Google Compute Engine instance. You're going to prepare a VM with the configurations you want to find into a base image. Please run this command in your Google Cloud Shell:

```bash
chmod +x *.sh
./1_create_base_instance.sh
```

Log into this machine via SSH button, you can find it beside the name of the instance in the Google Cloud Console GCE page. Execute these steps:

```bash
sudo su
apt-get update; apt-get install git-core -y
git clone https://github.com/favsto/intech-compute-balancing
mv intech-compute-balancing /usr/local/intech; cd /usr/local/intech/init/; chmod +x setup.sh
./setup.sh
exit
exit
```

Now, shutdown and delete inpho-base instance, WITHOUT DELETING ITS DISK! Please ensure that "Delete boot disk when instance is deleted" is unchecked within the detail page of your GCE instance. Then run this command:

```bash
# the number is the version of your image, feel free to increase it each time you run this command
./3_create_image.sh 1
```

You can delete inpho-base disk.

## Next steps

You can now initialize your codelab: [lab reset](../lab_reset/).