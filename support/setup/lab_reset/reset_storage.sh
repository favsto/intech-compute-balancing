#!/bin/bash

if [ $# -eq 0 ]
  then
    echo -e "ERROR: You must specify yout group ID"
    echo "Syntax: ./reset_storage.sh <GROUP_ID>"
    exit 1
fi

gsutil rm -r gs://inpho-group$1/*
gsutil rb gs://inpho-group$1
gsutil mb -l EU gs://inpho-group$1
