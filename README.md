# sftp-api-integration-demo
This demo shows how ZIP files on an SFTP server can be unzipped and synced to Cloud Storage, which can then make it easy to process and offer the data through APIs or events.

## Run locally
```sh
cd function
npm run local
```

## Test
```sh
# Process file data-18062024.zip from SFTP server to Cloud Storage.
curl -X POST 0:8080?fileLocation=/files/data-18062024.zip
```