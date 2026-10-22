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

resource "aws_s3_bucket" "gitops_demo" {
  bucket = "gitops-demo-mohammad-2026-12345" # Make sure this is unique!
  
  tags = {
    Environment = "dev"
    ManagedBy   = "github-actions"
  }
}
