# Refactored Terraform — Multi-Environment Deployment

This repo contains a refactored Terraform configuration that supports **multiple environments** (currently `dev` and `prod`) using a single, shared set of `.tf` files. Environment-specific values are supplied at runtime through `.tfvars` files.

---

## How to Deploy (One Command per Environment)

All commands are run from `~/devops-journey/day40/refactored-terraform`.

### 1. Initialize (first time only)

    terraform init

### 2. Deploy to dev

    terraform apply -var-file="envs/dev.tfvars"

### 3. Deploy to prod

    terraform apply -var-file="envs/prod.tfvars"

### 4. Preview changes (recommended before apply)

    terraform plan -var-file="envs/dev.tfvars"
    terraform plan -var-file="envs/prod.tfvars"

### 5. Tear down an environment

    terraform destroy -var-file="envs/dev.tfvars"
    terraform destroy -var-file="envs/prod.tfvars"

### 6. Inspect outputs

    terraform output                                  # all outputs
    terraform output -raw public_ip                   # just the IP
    terraform output -raw ssh_command                 # ready-to-paste SSH
    terraform output -json deployment_summary | jq    # JSON summary

---

## Where Secrets Should Go (NOT in .tfvars)

**Never commit secrets (AWS keys, DB passwords, API tokens) into `.tfvars` files or any file tracked by Git.**

`.tfvars` files are for **non-sensitive, environment-specific configuration** only (e.g., `instance_type`, `environment`, `project`). They are plain text and typically committed to the repo.

### Recommended approaches for secrets

| Method                                                      | When to use                              |
|-------------------------------------------------------------|------------------------------------------|
| Environment variables (`export AWS_ACCESS_KEY_ID=...`)      | Local dev, quick testing                 |
| AWS CLI profiles (`~/.aws/credentials`)                     | Local dev with named profiles            |
| IAM roles (EC2, ECS, Lambda instance roles)                 | Production workloads on AWS              |
| HashiCorp Vault                                             | Centralized secrets management           |
| AWS Secrets Manager / SSM Parameter Store                   | AWS-native secret storage                |
| Terraform Cloud / HCP Terraform variables (marked sensitive)| Remote state + CI/CD                     |
| CI/CD secret stores (GitHub Actions, GitLab CI)             | Pipelines                                |

### If you must pass a secret to Terraform

Use a **sensitive variable** and supply it via an environment variable:

    # variable.tf
    variable "db_password" {
      type      = string
      sensitive = true
    }

    # Pass via env var — Terraform reads TF_VAR_<name>
    export TF_VAR_db_password="super-secret"
    terraform apply -var-file="envs/dev.tfvars"

Add `*.tfvars` containing real secrets to `.gitignore` (or better, never create them).

---

## How to Add a New Environment (e.g., uat)

Adding an environment is a **two-step** process — no changes to `.tf` files are required, thanks to `locals.tf` and variable-driven naming.

### Step 1: Create the .tfvars file

    cp envs/dev.tfvars envs/uat.tfvars

Edit `envs/uat.tfvars` and change the environment-specific values:

    environment   = "uat"
    instance_type = "t3.small"
    # ... any other overrides

Naming (`myapp-uat-web`, `myapp-uat-web-sg`, etc.) and tags are derived automatically from the `environment` variable via `locals.tf`.

### Step 2: Deploy

    terraform apply -var-file="envs/uat.tfvars"

Tear down with:

    terraform destroy -var-file="envs/uat.tfvars"

---

## How It Works (Quick Overview)

- `variable.tf` declares inputs like `environment`, `instance_type`, `project`, `owner`.
- `envs/*.tfvars` supplies values for those inputs per environment.
- `locals.tf` builds consistent names and tags, e.g.:
  - `Name = "myapp-${var.environment}-web"`
  - `tags = { Environment = var.environment, Project = var.project, ... }`
- `main.tf` uses those locals to create the EC2 instance and security group.
- `output.tf` exposes `public_ip`, `ssh_command`, `instance_id`, and a `deployment_summary` map.

Because everything derives from the `environment` variable, adding `uat` requires **only a new `.tfvars` file** — the code stays untouched.

---

## Notes & Best Practices

- **State files are local** by default. For team use, migrate to a remote backend (S3 + DynamoDB) with a unique key per environment.
- **Don't commit** `terraform.tfstate`, `terraform.tfstate.backup`, or `.terraform/` — add them to `.gitignore`.
- **Do commit** `.terraform.lock.hcl` to pin provider versions.
- **Never put secrets** in `.tfvars`. Use env vars, IAM roles, or a secrets manager.
- Always run `terraform plan` before `terraform apply`, especially for `prod`.
