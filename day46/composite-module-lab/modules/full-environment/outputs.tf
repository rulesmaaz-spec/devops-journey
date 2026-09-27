output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "web_server_ips" {
  description = "Map of web server name → public IP"
  value       = { for k, v in module.web_server : k => v.public_ip }
}

output "web_urls" {
  description = "URLs for all web servers"
  value       = [for v in module.web_server : "http://${v.public_ip}"]
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = module.s3.bucket_arn
}
