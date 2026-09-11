# VPC Lab Notes 

## What I Built
- VPC: devops-vpc (10.0.0.0/16)
- 4 subnets across 2 AZs (public/private in each)
- Internet Gateway: devops-igw
- Public route table (0.0.0.0/0 → IGW)
- Private route table (no internet route)

## Commands Used
[List the commands you ran]

## Key Learnings
- Public subnets need a route to IGW
- Private subnets have no direct internet
- Route tables control traffic direction
- VPC CIDR cannot be changed after creation
