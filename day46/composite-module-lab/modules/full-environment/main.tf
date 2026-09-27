# ============================================
# Full Environment Module — Composition
# ============================================
# This module calls three child modules:
#   1. vpc — networking
#   2. web-server — compute
#   3. s3-bucket — storage
# ============================================

# ---------- VPC Module ----------
module "vpc" {
  source = "../vpc"

  vpc_cidr        = var.vpc_cidr
  environment     = var.environment
  project_name    = var.project_name
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# ---------- Security Group for Web Tier ----------
resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Web tier security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP"
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
    Name        = "${var.project_name}-${var.environment}-web-sg"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ---------- Web Server Module (called N times) ----------
module "web_server" {
  source   = "../web-server"
  for_each = toset([for i in range(var.web_instance_count) : tostring(i)])

  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_ids[tonumber(each.key) % length(module.vpc.public_subnet_ids)]
  security_group_ids = [aws_security_group.web.id]
  key_name           = var.key_name
  environment        = var.environment
  project_name       = var.project_name
  server_name        = "web-${tonumber(each.key) + 1}"
  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    server_name = "web-${tonumber(each.key) + 1}"
    environment = var.environment
    project_name = var.project_name
  })
}

# ---------- S3 Bucket Module ----------
module "s3" {
  source = "../s3-bucket"

  bucket_name       = "${var.project_name}-${var.environment}-assets-${var.bucket_suffix}"
  environment       = var.environment
  project_name      = var.project_name
  enable_versioning = true
}

# ---------- Data Source for AMI ----------
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
