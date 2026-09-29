# Terraform Cloud — Demo

## Setup
- Organization: mohammad-devops
- Workspace: day48-tfc-demo
- Workflow: CLI-driven

## Credentials
- AWS credentials stored as sensitive environment variables
- Never committed to Git

## Deployment
```bash
terraform init      # Configures TFC backend
terraform plan      # Runs remotely on TFC
terraform apply     # Applies after approval
terraform destroy   # Cleans up
