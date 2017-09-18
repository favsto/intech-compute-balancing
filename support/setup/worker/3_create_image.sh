# shutdown and delete inpho-base instance, WITHOUT DELETING ITS DISK!

gcloud compute --project=<PROJECT_ID> images create inpho-<A_VERSION> --family=inpho --source-disk=inpho-base --source-disk-zone=europe-west3-a

# now you should create/reset the instance template, please see the section /setup/project