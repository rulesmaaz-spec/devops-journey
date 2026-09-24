# backend.tf

terraform {
  backend "s3" {
    bucket       = "mohammad-terraform-state-2026"
    key          = "day44/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

