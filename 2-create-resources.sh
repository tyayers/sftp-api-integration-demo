gcloud config set project $PROJECT_ID

echo "Enabling APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

echo "Creating service account and assigning roles..."
gcloud iam service-accounts create sftpservice \
    --description="Service account to manage sftp services" \
    --display-name="SftpService"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:sftpservice@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/integrations.integrationInvoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:sftpservice@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:sftpservice@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectUser"

echo "Creating storage bucket..."
gcloud storage buckets create gs://$BUCKET_NAME --location=eu

echo "Creating integration auth profile..."
curl -X POST "https://integrations.googleapis.com/v1/projects/$PROJECT_ID/locations/$REGION/authConfigs" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H 'Content-Type: application/json; charset=utf-8' \
  --data-binary @- << EOF

{
  "displayName": "SFTP Zip Function Auth",
  "decryptedCredential": {
    "credentialType": "OIDC_TOKEN",
    "oidcToken": {
      "serviceAccountEmail": "sftpservice@$PROJECT_ID.iam.gserviceaccount.com",
      "audience": "https://europe-west4-apigee-test74.cloudfunctions.net/sftp-zip-function"
    }
  }
}
EOF