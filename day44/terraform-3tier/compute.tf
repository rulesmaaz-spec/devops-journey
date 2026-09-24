# compute.tf

resource "aws_instance" "web" {
  count                  = var.web_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index % length(aws_subnet.public)].id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "devops-journey-key"

  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    project_name      = var.project_name
    environment       = var.environment
    availability_zone = var.public_subnets[count.index % length(aws_subnet.public)].az
  })

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web-${count.index + 1}"
    Role = "web"
  })
}

