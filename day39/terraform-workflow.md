# Terraform Workflow Cheat Sheet

## Init
- Downloads providers
- Initializes backend
- Creates .terraform/ and .terraform.lock.hcl
- Run after cloning, changing providers, or modifying backend

## Plan
- Compares state vs config
- Shows + create, ~ update, - destroy, -/+ replace
- Save with `-out=tfplan` for CI/CD
- NEVER skip this in production

## Apply
- Executes the plan
- Updates state file
- Respects dependency graph
- Use `apply tfplan` for pre-approved plans

## Destroy
- Deletes all resources
- Uses reverse dependency order
- Use `-target` for selective deletion
- Use `prevent_destroy` lifecycle for critical resources

## State
- JSON file tracking all resources
- NEVER edit manually
- NEVER commit to Git
- Use remote state (S3 + DynamoDB) for teams

## Dependency Graph
- Terraform builds it from references
- Example: `aws_subnet.vpc_id = aws_vpc.main.id` creates a dependency
- Resources created in parallel where possible

## Common Patterns
| Task | Command |
|------|---------|
| Re-initialize after config change | `terraform init -upgrade` |
| Preview without applying | `terraform plan` |
| Save plan for review | `terraform plan -out=tfplan` |
| Apply saved plan | `terraform apply tfplan` |
| See all managed resources | `terraform state list` |
| Inspect a resource | `terraform state show aws_instance.web` |
| Remove resource from state (keep in AWS) | `terraform state rm aws_instance.web` |
| Import existing resource | `terraform import aws_instance.web i-0abc123` |
| Destroy one resource | `terraform destroy -target=aws_instance.web` |
