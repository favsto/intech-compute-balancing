# Support area

This folder contains support files. There are some scripts that can halp you in several moments: 
* public: it contains all files that need to be uploaded on a Google Cloud Storage bucket and each of them must be set as public
* setup/worker_image: it contains base configurations and the instructions to build of the GCE worker image
* setup/lab_reset: it contains other steps to correctly configure the Google Cloud Console project environment
* codelab: if you follow my codelab and you can't go on, here are some useful scripts that automatize the creation of the resources
* help: it contains a lot of run and test utilities, you should use them when the codelab is completed

## How do I set up the environment?

**NOTICE**: before starting, this codelab will use 2 different GCC projects: one project for common assets (Assets Project) and another one that contains all the workers (Workers Project).

First, create and configure Assets Project. Please follow this guide: [setup assets project](/support/setup/worker_image/).

Then, create and configure Workers Project. Please follow this guide: [setup workers project](/support/setup/lab_reset/).