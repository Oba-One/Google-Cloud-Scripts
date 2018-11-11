# CONFIGURATION STEPS FOR KUBERNETES AND CLOUD BUILD


## Cloud Build Deployment


### 1. Create a development branch and push it to the Git server.
git checkout -b new-feature

### 2. Edit html.go and main.go with slight modifications in color and version

### 3. Commit and push changes.
git add html.go main.go
git commit -m "Version 2.0.0"
git push gcp new-feature

### 4. View Build In Cloud Build Console

### 5. Retrieve the external IP for the production services.
kubectl get service gceme-frontend -n new-feature
export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=new-feature services gceme-frontend)

curl http://$FRONTEND_SERVICE_IP/version 

### 6. Create a canary branch and push it to the Git server.
git checkout master
git merge new-feature
git push gcp master

### 7. Check the service URL to ensure that some traffic is served by new version
while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1;  done

### 8. Merge the canary branch and push it to the Git server.
git tag v2.0.0
git push gcp v2.0.0