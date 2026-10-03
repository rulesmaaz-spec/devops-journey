# Terraform Testing Report

## Tools Used
| Tool | Purpose | Command |
|------|---------|---------|
| terraform fmt | Formatting | `terraform fmt -recursive` |
| terraform validate | Syntax | `terraform validate` |
| tflint | Best practices | `tflint -f compact` |
| checkov | Security | `checkov -d . --quiet` |

## Issues Found and Fixed

### Issue 1: SSH open to 0.0.0.0/0
- **Check:** CKV_AWS_24
- **Resource:** aws_security_group.web
- **Fix:** Restricted to specific IP

### Issue 2: S3 bucket versioning not enabled
- **Check:** CKV_AWS_21
- **Resource:** aws_s3_bucket.assets
- **Fix:** Added aws_s3_bucket_versioning resource

## Pre-commit Hook
Installed at `.pre-commit-config.yaml`. Runs all four checks before every commit.

## GitHub Actions
Workflow at `.github/workflows/terraform-checks.yml`. Runs on every PR.

## Lessons Learned
- fmt and validate catch syntax; tflint and checkov catch real problems
- Pre-commit hooks save time by catching issues early
- CI checks are non-negotiable in production
- Security checks (checkov) are the most valuable — they prevent breaches

