output "web_ip" {
  value = aws_instance.web.public_ip
}

output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}
