# CONFIGURATION STEPS FOR KUBERNETES AND CLOUD BUILD

## Google Cloud Configuration

### 1. Setup Enviroment Variables & Store Values
export PROJECT=$(gcloud info --format='value(config.project)')
export ZONE=us-central1-b
export CLUSTER=gke-deploy-cluster

gcloud config set project $PROJECT
gcloud config set compute/zone $ZONE

### 2. Enable GCP APIs
gcloud services enable container.googleapis.com --async
gcloud services enable containerregistry.googleapis.com --async
gcloud services enable cloudbuild.googleapis.com --async
gcloud services enable sourcerepo.googleapis.com --async

### Clone Sample Code From Github & CD to Directory
git clone https://github.com/GoogleCloudPlatform/container-builder-workshop.git
cd container-builder-workshop

### Start your Kubernetes cluster with 5 nodes
gcloud container clusters create ${CLUSTER} \
    --project=${PROJECT} \
    --zone=${ZONE} \
    --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

### Give Cloud Build Rights Cluster
export PROJECT_NUMBER="$(gcloud projects describe \
    $(gcloud config get-value core/project -q) --format='get(projectNumber)')"

gcloud projects add-iam-policy-binding ${PROJECT} \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/container.developer

### The enviroment is now ready.




