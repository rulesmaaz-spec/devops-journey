# outputs.tf
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ~/.ssh/aws/devops-journey-key.pem ubuntu@${aws_instance.web.public_ip}"
}

output "deployment_summary" {
  description = "Summary of this deployment"
  value = {
    environment   = var.environment
    region        = data.aws_region.current.name
    account_id    = data.aws_caller_identity.current.account_id
    instance_type = var.instance_type
    web_url       = "http://${aws_instance.web.public_ip}"
  }
}