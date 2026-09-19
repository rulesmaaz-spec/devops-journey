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
    error_message = "Environment must be dev, staging, or prod."
  }
}

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

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"   # Override with your IP

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "allowed_ports" {
  description = "Ports to allow inbound"
  type        = list(number)
  default     = [22, 80, 443]
}