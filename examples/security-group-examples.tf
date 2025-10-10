# Example 1: Web server with predefined rules
module "web_sg" {
  source = "../security_group"
  
  name        = "web-server-sg"
  description = "Security group for web servers"
  vpc_id      = "vpc-12345678"
  
  predefined_rule_sets = ["web", "ssh", "all_outbound"]
  allowed_cidr_blocks  = ["10.0.0.0/8"]
}

# Example 2: Database server with custom rules
module "db_sg" {
  source = "../security_group"
  
  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = "vpc-12345678"
  
  predefined_rule_sets = ["database", "all_outbound"]
  
  custom_ingress_rules = [
    {
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.1.0/24"]
      description = "MySQL from app tier"
    }
  ]
}

# Example 3: Custom application with mixed rules
module "app_sg" {
  source = "../security_group"
  
  name        = "application-sg"
  description = "Security group for application"
  vpc_id      = "vpc-12345678"
  
  predefined_rule_sets = ["ssh", "all_outbound"]
  allowed_cidr_blocks  = ["10.0.0.0/16"]
  
  custom_ingress_rules = [
    {
      port        = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Application port"
    },
    {
      from_port   = 9000
      to_port     = 9999
      protocol    = "tcp"
      self        = true
      description = "Internal communication"
    }
  ]
}

# Example 4: Redis cluster
module "redis_sg" {
  source = "../security_group"
  
  name        = "redis-cluster-sg"
  description = "Security group for Redis cluster"
  vpc_id      = "vpc-12345678"
  
  predefined_rule_sets = ["redis", "all_outbound"]
}