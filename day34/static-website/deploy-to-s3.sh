#!/bin/bash
# Deploy static website to S3

BUCKET_NAME="devops-journey-mohammad"
REGION="me-south-1"
WEBSITE_DIR="./static-website"

# Upload files
aws s3 sync "$WEBSITE_DIR" "s3://$BUCKET_NAME/" --region "$REGION"

# Enable static website hosting
aws s3 website "s3://$BUCKET_NAME/" \
  --index-document index.html \
  --error-document error.html

# Set public read policy
aws s3api put-bucket-policy --bucket "$BUCKET_NAME" --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::'"$BUCKET_NAME"'/*"
    }
  ]
}'

echo "Website deployed to: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
