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

# ---------- Data sources ----------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------- VPC Module ----------
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  project_name = var.project_name

  public_subnets = [
    { cidr = "10.0.1.0/24", az = "ap-south-1a" },
    { cidr = "10.0.3.0/24", az = "ap-south-1b" }
  ]
  private_subnets = [
    { cidr = "10.0.2.0/24", az = "ap-south-1a" },
    { cidr = "10.0.4.0/24", az = "ap-south-1b" }
  ]
}

# ---------- Security Group (for the web servers) ----------
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Web tier SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web-sg"
  }
}

# ---------- Web Server Module (called twice) ----------
module "web_server_1" {
  source = "./modules/web-server"

  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [aws_security_group.web.id]
  key_name           = var.key_name
  environment        = var.environment
  project_name       = var.project_name
  server_name        = "web-1"
  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    server_name = "web-1"
    environment = var.environment
  })
}

module "web_server_2" {
  source = "./modules/web-server"

  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[1]
  security_group_ids = [aws_security_group.web.id]
  key_name           = var.key_name
  environment        = var.environment
  project_name       = var.project_name
  server_name        = "web-2"
  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    server_name = "web-2"
    environment = var.environment
  })
}

# ---------- S3 Module ----------
module "s3" {
  source = "./modules/s3-bucket"

  bucket_name       = "${var.project_name}-${var.environment}-assets-${var.bucket_suffix}"
  environment       = var.environment
  project_name      = var.project_name
  enable_versioning = true
}
