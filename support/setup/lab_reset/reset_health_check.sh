echo "I'm trying to delete the old Health Check, eventually..."
gcloud compute http-health-checks delete "inpho-health-check" --quiet
echo "Now I can create a new Health Check for you..."
gcloud compute http-health-checks create "inpho-health-check" --description "This HC checks the healthy of the VMs both for managed groups and for Load Balancer" --port "80" --request-path "/healthcheck" --check-interval "30" --timeout "29" --unhealthy-threshold "3" --healthy-threshold "2" --quiet
