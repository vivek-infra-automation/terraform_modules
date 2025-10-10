variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "instance_name" {
  description = "Base name for EC2 instances"
  type        = string
}

variable "associate_public_ip" {
  description = "Associate public IP address"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}

variable "encrypt_root_volume" {
  description = "Encrypt root volume"
  type        = bool
  default     = true
}

variable "delete_root_on_termination" {
  description = "Delete root volume on termination"
  type        = bool
  default     = true
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices"
  type = list(object({
    device_name           = string
    volume_type           = string
    volume_size           = number
    encrypted             = bool
    delete_on_termination = bool
  }))
  default = []
}

variable "create_eip" {
  description = "Create Elastic IP for instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "project_id" {
  description = "ID of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}