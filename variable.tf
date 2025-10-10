variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_id" {
  description = "ID of the project"
  type        = string
  default     = "my-project"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my-project"
}



variable "vpc_count" {
  description = "Number of VPCs to create"
  type        = number
  default     = 1
}

variable "vpc_configs" {
  description = "List of VPC configurations"
  type = list(object({
    name               = string
    cidr               = string
    public_subnets     = list(string)
    private_subnets    = list(string)
    enable_nat_gateway = optional(bool, true)
  }))
  default = [{
    name               = "main-vpc"
    cidr               = "10.0.0.0/16"
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]
    enable_nat_gateway = true
  }]
}

variable "vpc_endpoints" {
  description = "List of VPC endpoints to create"
  type = list(object({
    vpc_index    = number
    service_name = string
    type         = string
  }))
  default = []
}

variable "ec2_deployments" {
  description = "EC2 deployment configuration per VPC"
  type = list(object({
    vpc_index      = number
    instance_count = number
    instance_name  = string
    subnet_type    = string # "public" or "private"
  }))
  default = []
}



variable "os_type" {
  description = "Operating system type (amazon-linux or ubuntu)"
  type        = string
  default     = "amazon-linux"
  validation {
    condition     = contains(["amazon-linux", "ubuntu"], var.os_type)
    error_message = "OS type must be either 'amazon-linux' or 'ubuntu'."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
  validation {
    condition     = length(var.key_name) > 0
    error_message = "Key name cannot be empty."
  }
}




variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


    