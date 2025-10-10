variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_ingress_rules" {
  description = "Additional custom ingress rules"
  type = list(object({
    port            = optional(number)
    from_port       = optional(number)
    to_port         = optional(number)
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
    self            = optional(bool, false)
    description     = optional(string, "")
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
  default     = {}
}