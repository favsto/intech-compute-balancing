#!/bin/bash

GCE_SERVICE_ACCOUNT="$(gcloud compute project-info describe | grep 788497779413 | awk '{ print $2; }')"