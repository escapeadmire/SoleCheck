gcloud functions deploy getShoeData \
  --runtime nodejs \
  --trigger-http \
  --region us-west1 \
  --allow-unauthenticated # Important for testing, remove in production
