locals {
  # Basic ingress rules
  basic_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "SSH"
    }
  ]
  
  # Additional custom rules
  additional_rules = [
    for rule in var.additional_ingress_rules : {
      from_port       = rule.port != null ? rule.port : rule.from_port
      to_port         = rule.port != null ? rule.port : rule.to_port
      protocol        = rule.protocol
      cidr_blocks     = rule.cidr_blocks
      security_groups = rule.security_groups
      self            = rule.self
      description     = rule.description
    }
  ]
  
  # Combine all rules
  ingress_rules = concat(local.basic_ingress_rules, local.additional_rules)

  # Basic egress rules
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = try(ingress.value.cidr_blocks, null)
      security_groups = try(ingress.value.security_groups, null)
      self            = try(ingress.value.self, null)
      description     = try(ingress.value.description, null)
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}