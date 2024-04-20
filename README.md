# fly-log-shipper
everything you need to ship logs from fly.io app instances to GCP, S3, or BetterStack (basically https://github.com/superfly/fly-log-shipper but with the configurations I prefer)


## Setting up GCP

Choose your service account name, bucket name, and project id. Recommendations:
```
export PROJECT_ID="some-project-id"
export BUCKET_NAME="application-logs"
export SERVICE_ACCOUNT_NAME="logs-forwarder"
```

Use gcloud command line to...

1. Create a new logging bucket that will eventually store logs
```
gcloud logging buckets create ${BUCKET_NAME} --location=global --retention-days=180 --description="some description"
```
2. Create a new logging sink that will receive the logs from the shipper and write them to the bucket
```
gcloud logging sinks create application-logs-sink logging.googleapis.com/projects/${PROJECT_ID}/locations/global/buckets/application-logs --project=${PROJECT_ID}
```
3. Create a new service account user
```
gcloud iam service-accounts create ${SERVICE_USER_ACCOUNT_NAME} --description="writes gcp logs from outside gcp"  --display-name="logs forwarder"
```
4. Create service account credentials for the user, and prepare to ship those in this docker container
```
gcloud iam service-accounts keys create ./gcp_logging_user_credentials_${PROJECT_ID}.json --iam-account=${SERVICE_ACCOUNT_USER_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```
5. Grant the service account the ability to write logs
```
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=serviceAccount:${SERVICE_ACCOUNT_USER_NAME}@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/logging.logWriter
```

Then bake the credentials file in the docker container, set your GOOGLE_CREDNETIALS env var, and deploy