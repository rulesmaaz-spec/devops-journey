# VPC Lab Notes 

## What I Built
- VPC: devops-vpc (10.0.0.0/16)
- 4 subnets across 2 AZs (public/private in each)
- Internet Gateway: devops-igw
- Public route table (0.0.0.0/0 → IGW)
- Private route table (no internet route)
- Design
    VPC: 10.0.0.0/16 (devops-vpc)
      ├── AZ me-south-1a
      │   ├── Public Subnet:  10.0.1.0/24  (public-1a)
      │   └── Private Subnet: 10.0.2.0/24  (private-1a)
      ├── AZ me-south-1b
      │   ├── Public Subnet:  10.0.3.0/24  (public-1b)
      │   └── Private Subnet: 10.0.4.0/24  (private-1b)
      ├── Internet Gateway: devops-igw
      ├── Public Route Table: public-rt (routes 0.0.0.0/0 → IGW)
      └── Private Route Table: private-rt (no internet route)
## Commands Used
- Creating the VPC
- Enabling DNS hostname
- Create subnet
- Create internet gateway
- Attach IGW to VPC
- Create route table
    Public Route table
    Add Public Route Table to IGW
    Associate public subnet
    Private route table
    Associate private subnet
- Verify every thing
    List VPC
    List subnet
    List route table
 
## Key Learnings
- Public subnets need a route to IGW
- Private subnets have no direct internet
- Route tables control traffic direction
- VPC CIDR cannot be changed after creation
