# european managed group
gcloud compute instance-groups managed create inpho-managed-group-eu --base-instance-name inpho-mig-eu --description "Project InPho. European managed instance group of GCE instances" --region europe-west3 --size 0 --template inpho-instance-template
gcloud beta compute instance-groups managed set-autohealing inpho-managed-group-eu --http-health-check inpho-health-check --initial-delay 30 --region europe-west3
gcloud compute instance-groups managed set-autoscaling inpho-managed-group-eu --min-num-replicas 3 --max-num-replicas 10 --target-cpu-utilization 0.6 --cool-down-period 30 --region europe-west3

# american managed group
gcloud compute instance-groups managed create inpho-managed-group-us --base-instance-name inpho-mig-us --description "Project InPho. American managed instance group of GCE instances" --region us-east4 --size 0 --template inpho-instance-template
gcloud beta compute instance-groups managed set-autohealing inpho-managed-group-us --http-health-check inpho-health-check --initial-delay 30 --region us-east4
gcloud compute instance-groups managed set-autoscaling inpho-managed-group-us --min-num-replicas 3 --max-num-replicas 10 --target-cpu-utilization 0.6 --cool-down-period 30 --region us-east4