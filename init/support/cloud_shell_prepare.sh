#!/bin/bash

GCE_SERVICE_ACCOUNT="$(gcloud compute project-info describe | grep defaultServiceAccount | awk '{ print $2; }')"