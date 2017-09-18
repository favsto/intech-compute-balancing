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

**NOTICE**: this codelab will use 2 different GCC project, one project for common assets (Assets Project) and another one that contains all the workers (Workers Project).

## Assets project

This project contains all useful assets. The Workers Project needs these stuffs to kork as expected.

### Google Cloud Storage

Upload the whole content in the folder /support/public into a your bucket (this project uses the name "intech"). Then share publicly these items:

* background_fhd.jpg
* schema_dump_v2.gz
* startup.sh
* photos/*.jpg

Furthermore add to the bucket the permission Reader for the special usel "allUsers".

### Worker image

TODO:
1. create base instance
1. install and configure worker
1. create image