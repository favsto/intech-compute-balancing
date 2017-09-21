#!/bin/bash

gcloud compute instances delete launcher-eu --zone europe-west3-a --quiet
gcloud compute instances create "launcher-eu" --description "This instance is for calling your services from Europe" --zone "europe-west3-a" --machine-type "g1-small" --subnet "default" --maintenance-policy "MIGRATE" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "launcher-eu" --metadata 'startup-script=#!/bin/bash
sudo su
apt-get update
apt-get install apache2-utils -y
apt-get install git-core -y
git clone https://github.com/favsto/intech-compute-balancing/
rm -rf /usr/local/intech
mv intech-compute-balancing/support/help/ /usr/local/intech
rm -rf intech-compute-balancing/support/help/
cd /usr/local/intech
chmod +x *.sh'

gcloud compute instances delete launcher-us --zone us-east4-a --quiet
gcloud compute instances create "launcher-us" --description "This instance is for calling your services from America" --zone "us-east4-a" --machine-type "g1-small" --subnet "default" --maintenance-policy "MIGRATE" --image-family "debian-9" --image-project "debian-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "launcher-us" --metadata 'startup-script=#!/bin/bash
sudo su
apt-get update
apt-get install apache2-utils -y
apt-get install git-core -y
git clone https://github.com/favsto/intech-compute-balancing/
rm -rf /usr/local/intech
mv intech-compute-balancing/support/help/ /usr/local/intech
rm -rf intech-compute-balancing/support/help/
cd /usr/local/intech
chmod +x *.sh'