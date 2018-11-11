# CONFIGURATION STEPS FOR KUBERNETES AND CLOUD BUILD


## Cloud Repository Configuration


### 1. Create a copy of the gceme sample app and push it to Cloud Source Repositories.
git push 

### 2. Initialize the sample-app directory as its own Git repository.
gcloud alpha source repos create default
git init
git config credential.helper gcloud.sh
git remote add gcp https://source.developers.google.com/p/$PROJECT/r/default

### 3. Set the username and email address for your Git commits.
git config --global user.email "[EMAIL_ADDRESS]"
git config --global user.name "[USERNAME]"

### 4. Add, commit, and push the files.
git add .
git commit -m "Initial commit"
git push gcp master

