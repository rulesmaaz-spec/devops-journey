terraform {
  cloud {
    organization = "mohammad-devops"

    workspaces {
      name = "day48-tfc-demo"
    }
  }

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

resource "aws_s3_bucket" "demo" {
  bucket = "tfc-demo-bucket-mohammad-2026"

  tags = {
    Name      = "tfc-demo"
    ManagedBy = "terraform-cloud"
  }
}
