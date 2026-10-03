terraform {
  backend "s3" {
    bucket       = "mohammad-terraform-state-2026"
    key          = "day45/modules-lab.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
