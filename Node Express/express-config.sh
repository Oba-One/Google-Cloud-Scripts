# Hello World Express App Config

# 1. Clone Github Repo Into Cloud Console
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git && \
cd nodejs-docs-samples/appengine/hello-world/standard/

# 2. Run NPM Install to Install Dependencies
npm install

# 3. Run NPM Start to view preview in Cloud Console
npm start

# 4. Make sure App Engine Yaml File is located in root directory of code

# 5. Deploy to App Engine
gcloud app deploy

# 6. If Changes are made to code simply deploy again
gcloud app deploy