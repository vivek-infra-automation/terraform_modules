vpc_count = 3

vpc_configs = [
  {
    name               = "vpc-frontend"
    cidr               = "10.0.0.0/16"
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]
    enable_nat_gateway = false
  },
  {
    name               = "vpc-backend"
    cidr               = "10.1.0.0/16"
    public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
    private_subnets    = ["10.1.10.0/24", "10.1.20.0/24"]
    enable_nat_gateway = false
  },
  {
    name               = "vpc-database"
    cidr               = "10.2.0.0/16"
    public_subnets     = ["10.2.1.0/24", "10.2.2.0/24"]
    private_subnets    = ["10.2.10.0/24", "10.2.20.0/24"]
    enable_nat_gateway = false
  }
]

aws_region   = "us-east-1"
environment  = "dev"
project_id   = "multi-vpc"
project_name = "multi-vpc"
instance_type = "t2.micro"
os_type      = "ubuntu"
key_name     = "devops"

ec2_deployments = [
  {
    vpc_index      = 0
    instance_count = 1
    instance_name  = "frontend-web"
    subnet_type    = "public"
  },
  {
    vpc_index      = 1
    instance_count = 1
    instance_name  = "backend-api"
    subnet_type    = "public"
  },
  {
    vpc_index      = 2
    instance_count = 1
    instance_name  = "db-server"
    subnet_type    = "public"
  }
]

common_tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}