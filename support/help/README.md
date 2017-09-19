# Do you need some help?

You shouldn't need to use these files. You should follow the codelab, these files could help you only in case you aren't able to complete the codelab independently.

## The first step

Before starting be sure you can use a shell with a well configured gcloud tool. Please refer to [this link](../setup/worker_image/). Then you need to let executable each .sh file in this folder:

```bash
# enter into the /support/help project folder
chmod +x *.sh
```

## Create two managed instance groups

The condelab require 2 MIGs (Managed Instance Group) in two different world location: one in Europe, one in America. Please run:

```bash
./create_instance_groups.sh
```

## Create the Load Balancer

This command creates a global HTTP Load Balancer.

```bash
./create_iload_balancer.sh
```

## Next steps

Now you can run some stress test to your project!