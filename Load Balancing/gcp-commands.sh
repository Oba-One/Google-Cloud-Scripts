# Cloud Commands for setting up Instances and Load Balancing

# 1. Create Instance Template
gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh

# 2. Create Target Pool
gcloud compute target-pools create nginx-pool

# 3. Create Managed Instance Group
gcloud compute instance-groups managed create nginx-group \
         --base-instance-name nginx \
         --size 2 \
         --template nginx-template \
         --target-pool nginx-pool

# 4. List Instances 
gcloud compute instances list

# 5. Create Firewall To Only Allow Access on Port:80
gcloud compute firewall-rules create www-firewall --allow tcp:80

# 6. Create L3 Network Load Balancer
gcloud compute forwarding-rules create nginx-lb \
         --port-range 80 \
         --target-pool nginx-pool

# 7. Create Health Check for HTTP Load Balancing
gcloud compute http-health-checks create http-basic-check

# 8. Map HTTP Service to Port for Instance Group
 gcloud compute instance-groups managed \
      set-named-ports nginx-group \
      --named-ports http:80

# 9. Create Backend Service to Handle Traffic
gcloud compute backend-services create nginx-backend \
      --protocol HTTP --http-health-check http-basic-check

# 10. Add Backend To Instance Group
gcloud compute backend-services add-backend nginx-backend \
      --instance-group nginx-group 

# 11. Create URL Map That Maps All Request To NGINX Instances.
gcloud compute url-maps create web-map \
      --default-service nginx-backend

# 12. Make Target Proxy To Route Request To URL Map
gcloud compute target-http-proxies create http-lb-proxy \
      --url-map web-map

# 13. Create Global Forwarding Rule For Proxy 
gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --port-range 80   
