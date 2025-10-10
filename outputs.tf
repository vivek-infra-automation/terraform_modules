output "vpc_ids" {
  description = "All VPC IDs"
  value       = module.vpc.vpc_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "security_group_ids" {
  description = "Web security group IDs"
  value       = module.web_sg[*].security_group_id
}

output "instance_ids" {
  description = "EC2 instance IDs from all VPCs"
  value       = flatten([for server in module.web_servers : server.instance_ids])
}

output "instance_public_ips" {
  description = "EC2 instance public IPs from all VPCs"
  value       = flatten([for server in module.web_servers : server.public_ips])
}

output "elastic_ips" {
  description = "Elastic IP addresses from all VPCs"
  value       = flatten([for server in module.web_servers : server.elastic_ips])
}

output "selected_ami_id" {
  description = "Selected AMI ID"
  value       = var.os_type == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
}

output "availability_zones" {
  description = "Available zones used"
  value       = data.aws_availability_zones.available.names
}