#!/bin/bash

# reserve a dedicated external IP address 
echo "Creating external IP address..."
gcloud compute addresses create inpho-load-balancer-ip --global
LB_ADDRESS=$(gcloud compute addresses describe inpho-load-balancer-ip --global | grep address: | awk '{ print $2; }')

# a backend service that will route the traffic towards each backend
echo "Creating backend service..."
gcloud compute backend-services create inpho-backend-service --description "InPho Backend Service. It manages traffic towards EU and US." --protocol "HTTP" --port-name "http" --timeout 30 --http-health-check "inpho-health-check" --global --connection-draining-timeout 10

# a backend for each managed instance group
echo "Creating 2 backends..."
gcloud compute backend-services add-backend inpho-backend-service --instance-group inpho-managed-group-eu --balancing-mode UTILIZATION --capacity-scaler 1 --max-utilization 0.9 --global --instance-group-region europe-west3
gcloud compute backend-services add-backend inpho-backend-service --instance-group inpho-managed-group-us --balancing-mode UTILIZATION --capacity-scaler 1 --max-utilization 0.9 --global --instance-group-region us-east3

# the URL Map permits to specify traffic split based on content type, eventually. We don't need to specialize traffic routes
echo "Creating URL Map..."
gcloud compute url-maps create inpho-load-balancer --default-service inpho-backend-service

# a Target Proxy links the global frontend with the backend service(s)
echo "Creating Target Proxy..."
gcloud compute target-http-proxies create inpho-lb-target --url-map=inpho-load-balancer

# this is the frontend
echo "Creating LB frontend..."
gcloud compute forwarding-rules create inpho-frontend --global --address=$LB_ADDRESS --ip-protocol=TCP --ports=80 --target-http-proxy=inpho-lb-target