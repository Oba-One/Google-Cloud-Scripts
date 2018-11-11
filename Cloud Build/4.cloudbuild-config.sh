# CONFIGURATION STEPS FOR KUBERNETES AND CLOUD BUILD


## Cloud Build Configuration


### 1.  Build trigger to watch for changes to any branches except master.
cat <<EOF > branch-build-trigger.json
{
  "triggerTemplate": {
    "projectId": "${PROJECT}",
    "repoName": "default",
    "branchName": "[^(?!.*master)].*"
  },
  "description": "branch",
  "substitutions": {
    "_CLOUDSDK_COMPUTE_ZONE": "${ZONE}",
    "_CLOUDSDK_CONTAINER_CLUSTER": "${CLUSTER}"
  },
  "filename": "builder/cloudbuild-dev.yaml"
}
EOF

curl -X POST \
    https://cloudbuild.googleapis.com/v1/projects/${PROJECT}/triggers \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud config config-helper --format='value(credential.access_token)')" \
    --data-binary @branch-build-trigger.json

### 2. Build trigger to watch for changes to only the master branch.
cat <<EOF > master-build-trigger.json
{
  "triggerTemplate": {
    "projectId": "${PROJECT}",
    "repoName": "default",
    "branchName": "master"
  },
  "description": "master",
  "substitutions": {
    "_CLOUDSDK_COMPUTE_ZONE": "${ZONE}",
    "_CLOUDSDK_CONTAINER_CLUSTER": "${CLUSTER}"
  },
  "filename": "builder/cloudbuild-canary.yaml"
}
EOF


curl -X POST \
    https://cloudbuild.googleapis.com/v1/projects/${PROJECT}/triggers \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud config config-helper --format='value(credential.access_token)')" \
    --data-binary @master-build-trigger.json


### 3. Build trigger to execute when a tag is pushed to the repository.
cat <<EOF > tag-build-trigger.json
{
  "triggerTemplate": {
    "projectId": "${PROJECT}",
    "repoName": "default",
    "tagName": ".*"
  },
  "description": "tag",
  "substitutions": {
    "_CLOUDSDK_COMPUTE_ZONE": "${ZONE}",
    "_CLOUDSDK_CONTAINER_CLUSTER": "${CLUSTER}"
  },
  "filename": "builder/cloudbuild-prod.yaml"
}
EOF


curl -X POST \
    https://cloudbuild.googleapis.com/v1/projects/${PROJECT}/triggers \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud config config-helper --format='value(credential.access_token)')" \
    --data-binary @tag-build-trigger.json