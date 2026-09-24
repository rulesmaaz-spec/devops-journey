# AWS 3-Tier Infrastructure — Terraform

A production-grade Terraform project that provisions:
- VPC with public/private subnets across 2 Availability Zones
- Internet Gateway + route tables
- Web security group (SSH + HTTP)
- Auto-configured EC2 web servers (nginx via user_data)
- S3 bucket with versioning and encryption

## Architecture

[Insert your diagram here]

## Prerequisites
- AWS account with credentials configured
- Terraform 1.5+
- SSH key pair named `devops-journey-key` in your AWS account

## Usage

```bash
cd terraform-3tier
terraform init
terraform plan -var-file="envs/dev.tfvars"
terraform apply -var-file="envs/dev.tfvars"

