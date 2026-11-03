terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "ap-south-1" }

# Default VPC
resource "aws_default_vpc" "default" {}

# 1. Security Group (SSH + HTTP)
resource "aws_security_group" "web" {
  name   = "tf-ansible-demo-sg"
  vpc_id = aws_default_vpc.default.id # <-- THIS is the missing piece

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instance
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "capstone-02" # CHANGE key is different

  tags = { Name = "tf-ansible-demo" }
}

# 3. Generate the Ansible Inventory file dynamically
resource "local_file" "ansible_inventory" {
  content  = <<EOT
[webservers]
${aws_instance.web.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws/capstone-02.pem
EOT
  filename = "${path.module}/inventory.ini"
}

# 4. Trigger Ansible (The Integration)
resource "null_resource" "run_ansible" {
  # Re-run Ansible only if the EC2 instance IP changes
  triggers = {
    instance_ip = aws_instance.web.public_ip
  }

  # We need the inventory file to exist before running Ansible
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "sleep 20 && ansible-playbook -i inventory.ini configure.yml"
  }
}
