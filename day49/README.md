# Importing Legacy Infrastructure

## What I Imported
- S3 bucket: legacy-bucket-mohammad-2026
- Security group: legacy-sg
- EC2 instance: i-0abc123

## Import Commands
[Each `terraform import` command you ran]

## Lessons Learned
- Import requires exact resource IDs
- Config must match reality (mostly) for a clean plan
- Import blocks (Terraform 1.5+) are the modern way
- Drift detection catches manual changes
- terraform state commands are powerful — and dangerous

## Key Commands
- `terraform import <type>.<name> <id>` — attach existing resource
- `terraform plan -refresh-only` — detect drift
- `terraform state list` — see all managed resources
- `terraform state mv` — rename in state
- `terraform state rm` — unmanage without deleting
