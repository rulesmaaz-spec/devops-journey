terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# This resource already exists in AWS.
# We'll import it instead of creating it.
resource "aws_s3_bucket" "legacy" {
  bucket = "legacy-bucket-mohammad-2026"
}

