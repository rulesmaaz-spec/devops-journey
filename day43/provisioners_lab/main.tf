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

# Security group
resource "aws_security_group" "web_sg" {
  name = "${var.project_name}-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
}

# Backend instance (private internal service)
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "${var.project_name}-backend"
    Role = "backend"
  }
}

# Web instance — uses templatefile for user_data
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = templatefile("${path.module}/templates/bootstrap.sh.tpl", {
    backend_ip   = aws_instance.backend.private_ip
    environment  = var.environment
    project_name = var.project_name
  })

  tags = {
    Name = "${var.project_name}-web"
  }

  # Local-exec: write the public IP to a file
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > /tmp/${var.project_name}-ip.txt"
  }
}

# Null resource: run a post-deploy action if the URL changes
resource "null_resource" "post_deploy" {
  triggers = {
    web_ip = aws_instance.web.public_ip
  }

  provisioner "local-exec" {
    command = "echo 'Deployed at http://${aws_instance.web.public_ip}' >> /tmp/deployment-log.txt"
  }
}
