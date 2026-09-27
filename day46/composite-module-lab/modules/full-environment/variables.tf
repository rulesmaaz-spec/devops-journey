# ============================================
# Full Environment Module — Inputs
# ============================================
# This module takes minimal inputs and produces
# a complete 3-tier environment.
# ============================================

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
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
}

variable "private_subnets" {
  description = "Private subnet CIDRs and AZs"
  type = list(object({
    cidr = string
    az   = string
  }))
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "web_instance_count" {
  description = "Number of web servers"
  type        = number
  default     = 2
}

variable "bucket_suffix" {
  description = "Unique suffix for S3 bucket"
  type        = string
}
