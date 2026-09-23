output "web_server_ips" {
  description = "IPs of the web servers (count)"
  value       = aws_instance.web[*].public_ip
}

output "service_ips" {
  description = "IPs of the service instances (for_each)"
  value       = { for k, v in aws_instance.services : k => v.public_ip }
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}
