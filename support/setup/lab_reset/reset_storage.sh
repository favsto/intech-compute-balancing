#!/bin/bash

gsutil rm gs://inpho-group$1/*
gsutil rb gs://inpho-group$1
gsutil mb -l EU gs://inpho-group$1
