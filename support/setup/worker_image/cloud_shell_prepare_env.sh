#!/bin/bash

# please note that this code works only within Google Cloud Shell
GCE_SERVICE_ACCOUNT="$(gcloud compute project-info describe | grep defaultServiceAccount | awk '{ print $2; }')"