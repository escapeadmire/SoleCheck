gcloud functions deploy getShoeData \
  --runtime nodejs16 \
  --trigger-http \
  --region YOUR_REGION \
  --allow-unauthenticated # Important for testing, remove in production
