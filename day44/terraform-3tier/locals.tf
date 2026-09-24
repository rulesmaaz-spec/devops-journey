# locals.tf

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "mohammad"
  }

  s3_bucket_name = "${var.project_name}-assets-${var.bucket_name_suffix}"
}
