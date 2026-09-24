# outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "web_instance_ids" {
  description = "Web instance IDs"
  value       = aws_instance.web[*].id
}

output "web_public_ips" {
  description = "Web instance public IPs"
  value       = aws_instance.web[*].public_ip
}

output "web_urls" {
  description = "URLs to reach each web server"
  value       = [for ip in aws_instance.web[*].public_ip : "http://${ip}"]
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.assets.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.assets.arn
}

output "deployment_summary" {
  description = "Summary of this deployment"
  value = {
    environment    = var.environment
    region         = var.aws_region
    instance_count = var.web_instance_count
    web_urls       = [for ip in aws_instance.web[*].public_ip : "http://${ip}"]
  }
}

