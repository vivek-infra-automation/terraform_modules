# VPC Module
module "vpc" {
  source = "./vpc"

  project_id         = var.project_id
  environment        = var.environment
  vpc_count          = var.vpc_count
  vpc_configs        = var.vpc_configs
  availability_zones = data.aws_availability_zones.available.names
  region             = var.aws_region
  vpc_endpoints      = var.vpc_endpoints

  tags = var.common_tags
}

# Security Groups for VPCs with EC2 deployments
module "web_sg" {
  count  = length(var.ec2_deployments)
  source = "./security_group"

  name        = "${var.project_name}-sg-${var.ec2_deployments[count.index].instance_name}"
  description = "Security group for ${var.ec2_deployments[count.index].instance_name}"
  vpc_id      = module.vpc.vpc_ids[var.ec2_deployments[count.index].vpc_index]

  allowed_cidr_blocks = ["0.0.0.0/0"]

  tags = var.common_tags
}

# EC2 instances based on deployment configuration
module "web_servers" {
  count  = length(var.ec2_deployments)
  source = "./ec2"

  project_id         = var.project_id
  instance_count     = var.ec2_deployments[count.index].instance_count
  ami_id             = var.os_type == "ubuntu" ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_ids = [module.web_sg[count.index].security_group_id]
  subnet_ids = var.ec2_deployments[count.index].subnet_type == "private" ? [module.vpc.private_subnet_ids[var.ec2_deployments[count.index].vpc_index * 2]] : [module.vpc.public_subnet_ids[var.ec2_deployments[count.index].vpc_index * 2]]
  instance_name      = var.ec2_deployments[count.index].instance_name

  associate_public_ip = var.ec2_deployments[count.index].subnet_type == "public"
  enable_monitoring   = false
  ebs_optimized       = false
  user_data           = file("scripts/apache2.sh")
  tags = var.common_tags
}