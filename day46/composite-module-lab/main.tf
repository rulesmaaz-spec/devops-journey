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
  region = var.aws_region
}

module "environment" {
  source = "./modules/full-environment"

  environment        = var.environment
  project_name       = var.project_name
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  instance_type      = var.instance_type
  key_name           = var.key_name
  ssh_allowed_cidr   = var.ssh_allowed_cidr
  web_instance_count = var.web_instance_count
  bucket_suffix      = var.bucket_suffix
}
