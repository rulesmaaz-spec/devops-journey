# S3 Static Website Hosting

## What This Does
Hosts a static website on Amazon S3 without any servers.

## Files
- `static-website/index.html` — Main page
- `static-website/error.html` — 404 page
- `deploy-to-s3.sh` — Deployment script

## How It Works
1. Script uploads files to S3 bucket
2. Enables static website hosting
3. Sets bucket policy for public read
4. Site available at S3 website URL

## Key S3 Features Demonstrated
- Static website hosting
- Bucket policies
- Public access configuration

## Commands (when AWS account is ready)
```bash
chmod +x deploy-to-s3.sh
./deploy-to-s3.sh


