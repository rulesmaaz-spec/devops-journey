variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "composite-app"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
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
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = "devops-journey-key"
}

variable "ssh_allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "web_instance_count" {
  type    = number
  default = 2
}

variable "bucket_suffix" {
  type    = string
  default = "mohammad-2026"
}
