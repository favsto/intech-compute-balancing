# Google Cloud Console Project Setup

## Requirements

Before starting you need:
1. a G Suite user account, with Google Developer Console enabled
1. an empty Google Cloud Console project associated with a valid billing account
1. if you want to use your machine, a command line interface with [gcloud](https://cloud.google.com/sdk/downloads) installed
1. you have done the steps in the project folder: [/setup/worker/](../worker/)

## Configure gcloud CLI

[if you missed this step before]

This is necessary only if you want to use your laptop shell. Once installed, gcloud needs to be configured with the right user and the working project.
Please run this command and follow its steps; when asked, select the project you're going to use with this lab.

```bash
gcloud init
```

## Google Cloud Console

[if you missed this step before]

Go to the [Google Cloud Console](https://cloud.google.com/consoele) and select your project. This is your working console, where all the magic happens.

Then, click on the button "Google Cloud Shell" in the up-right side of the page. You will see an awesome browser based shell. 

Please ensure that you copy/download this code in the location you choose as your favourite shell.

### Enable Google APIs

[if you missed this step before]

You need to navigate into the section APIs & services and to enable:

* Google Compute Engine API
* Google Cloud SQL
* Google Cloud Storage
* Google Cloud Storage JSON API
* Google Service Management API
* Google Cloud APIs

### Setup Google Cloud SQL

Navigate to the page SQL. Create a new Google Cloud SQL instance whit these configurations:

* type: MySQL 5.7
* generation: 2nd
* name: intech17
* region: europe-west3
* dimension: db-n1-standard1 (at least)

## Setup commands

In order to configure your project, please run these commands in the righ order:

```bash
# let each .sh executable
chmod +x *.sh

# run reset commands in this exact order
./reset_storage.sh
./reset_sql.sh
./reset_instance_template.sh
./reset_health_check.sh
```