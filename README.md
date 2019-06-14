# Injenia InTech
## Google Compute Engine Worker
Injenia Srl, InTech 2017 event.
This is a demo projet with Google Cloud Platform. This is the core of the codelab at: [https://sites.google.com/injenia.it/intech2017-balancing](https://sites.google.com/injenia.it/intech2017-balancing)

### Setup

This codelab is referred to a technical tour of Injenia Srl, Google Cloud Premier partner. If you partecipate at this event you'll be provided with an environment ready to use. If you want to setup your own environment just follow the steps into the section [support](/support).

### Architecture

You're going to create this architecture.

![InTech - InPho GCP Architecture](/images/architecture.png)

InPho (this is the name of my project) is a simple demo application. It involves a global HTTP Load Balancer, two Google Compute Engine Managed Instance Groups where InPho runs (frontend and backend), a single Google Cloud SQL (MySQL), two Google Cloud Storage buckets. Monitoring and logs are managed by the suite Google Stackdriver. The Health Check take care of the healthiness of each Google Compute Engine instance in the project.

The role of each worker (aka backend), who runs in a GCE instance, is to execute one of several jobs in a table within InPho DB. Each job retrieves an image from a public bucket, applies some transformations, saves the new version of this image into a project private bucket. All workers are managed with two autoscaled Instance Groups (located in Europe and America). When each client request arrives it will be routed from the Load Balancer towards the best worker.

## Author
Fausto Fusaro [fausto.fusaro@injenia.it](mailto:fausto.fusaro@injenia.it)  
Google Cloud Architect @ Injenia Srl

## Contributors
Any contributor is my friend... feel free to contribute! :)

# License

Apache License Version 2.0