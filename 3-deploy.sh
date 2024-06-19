gcloud config set project $PROJECT_ID

echo "Deploy cloud function..."
cd function
gcloud functions deploy sftp-zip-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=$REGION \
  --source=. \
  --entry-point=sftp-zip-handler \
  --trigger-http \
  --no-allow-unauthenticated \
  --min-instances=1 \
  --service-account=sftpservice@$PROJECT_ID.iam.gserviceaccount.com \
  --set-env-vars=SFTP_HOST=$SFTP_HOST,SFTP_PORT=$SFTP_PORT,SFTP_USER=$SFTP_USER,SFTP_PW=$SFTP_PW,BUCKET_NAME=$BUCKET_NAME
cd ..