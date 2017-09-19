#!/bin/bash

# shutdown and delete inpho-base instance, WITHOUT DELETING ITS DISK!

gcloud compute images create inpho-$1 --family=inpho --source-disk=inpho-base --source-disk-zone=europe-west3-a

# now you should create/reset the instance template, please see the section /setup/lab_reset