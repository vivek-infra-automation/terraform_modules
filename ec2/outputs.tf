output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_arns" {
  description = "List of EC2 instance ARNs"
  value       = aws_instance.main[*].arn
}

output "private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.main[*].private_ip
}

output "public_ips" {
  description = "List of public IP addresses"
  value       = aws_instance.main[*].public_ip
}

output "elastic_ips" {
  description = "List of Elastic IP addresses"
  value       = var.create_eip ? aws_eip.main[*].public_ip : []
}

output "instance_dns" {
  description = "List of public DNS names"
  value       = aws_instance.main[*].public_dns
}