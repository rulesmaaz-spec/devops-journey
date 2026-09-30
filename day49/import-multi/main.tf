# main.tf
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

resource "aws_s3_bucket" "legacy" {
  bucket = "legacy-bucket-mohammad-2026"
}

resource "aws_security_group" "legacy" {
  name        = "legacy-sg"
  description = "Legacy security group"
}

resource "aws_instance" "legacy" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
}
