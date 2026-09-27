terraform {
  backend "s3" {
    bucket       = "mohammad-terraform-state-2026"
    key          = "day46/composite-lab.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
