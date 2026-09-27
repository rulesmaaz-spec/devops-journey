# Composite Terraform Modules

Modules composed from smaller building blocks.

## Available Modules

### full-environment
Provisions an entire 3-tier AWS environment with one call.

**Creates:**
- VPC with public/private subnets across 2 AZs
- Internet Gateway and route tables
- Security group for web tier
- N web servers (EC2 + nginx)
- S3 bucket with versioning

**Inputs:**
- environment, project_name, aws_region
- vpc_cidr, public_subnets, private_subnets
- instance_type, key_name, ssh_allowed_cidr
- web_instance_count, bucket_suffix

**Outputs:**
- vpc_id, public_subnet_ids, private_subnet_ids
- web_server_ips (map), web_urls (list)
- s3_bucket_name, s3_bucket_arn

## Usage

```hcl
module "environment" {
  source = "git::https://github.com/rulesmaaz-spec/terraform-composite-modules.git//full-environment?ref=v1.0.0"

  environment        = "dev"
  project_name       = "myapp"
  web_instance_count = 3
  bucket_suffix      = "myapp-2026"
  # ... other inputs
}

## Composition Pattern
full-environment (composite)
├── vpc (foundation)
├── web-server (foundation)
└── s3-bucket (foundation)
