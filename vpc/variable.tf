variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "environment" {
  description = "The environment for which to provision resources (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
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
    name               = "my-vpc"
    cidr               = "10.0.0.0/16"
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
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

variable "availability_zones" {
  description = "A list of availability zones for the subnets."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-west-2"
}


variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  type        = bool
  default     = true
}



