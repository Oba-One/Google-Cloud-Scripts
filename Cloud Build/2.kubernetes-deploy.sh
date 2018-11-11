# CONFIGURATION STEPS FOR KUBERNETES AND CLOUD BUILD


## Kubernetes Deployment 


### 1. Create the Kubernetes namespace to logically isolate the deployment.
kubectl create ns production

### 2. Create the production and canary deployments and services using the kubectl apply commands.
kubectl apply -f kubernetes/deployments/prod -n production
kubectl apply -f kubernetes/deployments/canary -n production
kubectl apply -f kubernetes/services -n production

### 3. Scale up the production environment frontends.
kubectl scale deployment gceme-frontend-production -n production --replicas 4

### 4. Confirm 5 pods are running frontend: 4 prod 1 canary, backend: 1 prod 1 canary.
kubectl get pods -n production -l app=gceme -l role=frontend
kubectl get pods -n production -l app=gceme -l role=backend

### 5. Retrieve the external IP for the production services.
kubectl get service gceme-frontend -n production

### 6. Store the frontend service load balancer IP in an environment variable
export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}"  --namespace=production services gceme-frontend)

### 7. Check the version output of the service by hitting the /version path
curl http://$FRONTEND_SERVICE_IP/version

### 8. The application is deployed with a front and backend with multiple pods in production
### and a couple pods in canary.

