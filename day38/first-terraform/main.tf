# ============================================
# Terraform configuration
# ============================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ============================================
# AWS Provider
# ============================================

provider "aws" {
  region = "ap-south-1"
}

# ============================================
# Variables
# ============================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "devops-journey"
}

# ============================================
# Data source: Get latest Ubuntu AMI
# ============================================

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================
# Security Group for SSH + HTTP
# ============================================

resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # CHANGE THIS to your IP!
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# ============================================
# EC2 Instance
# ============================================

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    echo "<h1>first deployment by MOHAMMAD MAAZ on Terraform!</h1>" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
  EOF

  tags = {
    Name        = "${var.project_name}-web"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# ============================================
# Outputs
# ============================================

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web.public_dns
}


