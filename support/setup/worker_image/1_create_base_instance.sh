#!/bin/bash

# gcloud compute instances create "inpho-base" --zone "europe-west1-d" --machine-type "n1-standard-1" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --no-boot-disk-auto-delete --boot-disk-type "pd-ssd" --metadata "sql-connection-name=<CLOUD_SQL_CONNECTION_NAME>,destination-bucket=<OUTPUT_BUCKET_NAME>,sql-username=intech,sql-password=workshop2017"
gcloud compute instances create "inpho-base" --zone "europe-west1-d" --machine-type "n1-standard-1" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --no-boot-disk-auto-delete --boot-disk-type "pd-ssd"