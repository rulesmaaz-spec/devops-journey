locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "mohammad"
  }
  
  is_production = var.environment == "prod"
  
  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    echo "<h1>${var.project_name} - ${var.environment}</h1>" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
  EOF
}