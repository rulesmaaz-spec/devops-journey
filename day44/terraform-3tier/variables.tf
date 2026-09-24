# variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "three-tier"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs and AZs"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = [
    { cidr = "10.0.1.0/24", az = "ap-south-1a" },
    { cidr = "10.0.3.0/24", az = "ap-south-1b" }
  ]
}

variable "private_subnets" {
  description = "Private subnet CIDRs and AZs"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = [
    { cidr = "10.0.2.0/24", az = "ap-south-1a" },
    { cidr = "10.0.4.0/24", az = "ap-south-1b" }
  ]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_count" {
  description = "Number of web servers"
  type        = number
  default     = 2
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH (set this to your IP/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "bucket_name_suffix" {
  description = "Suffix to make the S3 bucket globally unique"
  type        = string
  default     = "mohammad-2026"
}
