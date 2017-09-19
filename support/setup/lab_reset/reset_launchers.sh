#!/bin/bash

gcloud compute instances delete launcher-eu --zone europe-west3-a --quiet
gcloud compute instances create "launcher-eu" --description "This instance is for calling your services from Europe" --zone "europe-west3-a" --machine-type "g1-small" --subnet "default" --no-address --maintenance-policy "MIGRATE" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "launcher-eu"

gcloud compute instances delete launcher-us --zone us-east4-a --quiet
gcloud compute instances create "launcher-us" --description "This instance is for calling your services from America" --zone "us-east4-a" --machine-type "g1-small" --subnet "default" --no-address --maintenance-policy "MIGRATE" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "launcher-us"