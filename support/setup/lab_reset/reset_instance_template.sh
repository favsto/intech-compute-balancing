# before starting: please notice that intech-lab-01 is the name of my Assets Project, feel free to change it with the yours

# update IAM role
PROJECT_ID=$(gcloud compute project-info describe --format=text | grep name | awk '{ print $2; }')
echo "Your project ID is: $PROJECT_ID"
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format=text | grep projectNumber | awk '{ print $2; }')
echo "Have you ever authorized this project to use the images within the project intech-lab-01?"
echo "Otherwise, you need to run this command with an owner of the project intech-lab-01: "
echo "gcloud projects add-iam-policy-binding intech-lab-01 --member serviceAccount:$PROJECT_NUMBER@cloudservices.gserviceaccount.com --role roles/compute.imageUser"
read -rsp $'Press enter to continue...\n'

echo "I'm deleting the current instance template, if it exists..."
gcloud compute instance-templates delete "inpho-instance-template" --quiet

echo "I'm creating a brand new instance template..."
GCE_SERVICE_ACCOUNT="$(gcloud compute project-info describe | grep defaultServiceAccount | awk '{ print $2; }')"
gcloud compute instance-templates create "inpho-instance-template" \
  --machine-type "n1-standard-1" --network "default" \
  --metadata "sql-connection-name=intech17-group-01:europe-west3:intech17,destination-bucket=inpho-group01,sql-username=intech,sql-password=workshop2017,startup-script-url=gs://intech/startup.sh" \
  --scopes https://www.googleapis.com/auth/sqlservice.admin,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.full_control \
  --service-account=$GCE_SERVICE_ACCOUNT \
  --tags "http-server" \
  --image-project "intech-lab-01" \
  --image-family "inpho" \
  --boot-disk-size "10" --boot-disk-type "pd-ssd"
echo "Creation of the instance template requested correctly"

# echo "Now you can run this command with an owner of the project intech-lab-01: "
# echo "gcloud projects remove-iam-policy-binding intech-lab-01 --member serviceAccount:$PROJECT_NUMBER@cloudservices.gserviceaccount.com --role roles/compute.imageUser"
# read -rsp $'Press enter to continue...\n'

# update firewall rules
gcloud beta compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --allow=tcp:80 --source-ranges=0.0.0.0/0