# Terraform AWS Infrastructure Modules

Complete Terraform modules for AWS infrastructure deployment with VPC, Security Groups, and EC2 instances.

## Modules

### VPC Module (`./vpc/`)
- Creates VPC with public/private subnets
- Internet Gateway and NAT Gateways
- Route tables and associations
- Multi-AZ support

### Security Group Module (`./security_group/`)
- Web server security group (HTTP, HTTPS, SSH)
- Configurable CIDR blocks
- All outbound traffic allowed

### EC2 Module (`./ec2/`)
- Multiple EC2 instances
- EBS volumes with encryption
- Optional Elastic IPs
- Auto-scaling across subnets

## Quick Start

1. **Configure variables:**
```bash
cp terraform.tfvars terraform.tfvars.local
# Edit terraform.tfvars.local with your values
```

2. **Deploy:**
```bash
terraform init
terraform plan
terraform apply
```

## Configuration Options

### New VPC (default)
```hcl
use_existing_vpc = false
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
```

### Existing VPC
```hcl
use_existing_vpc = true
vpc_id = "vpc-12345678"  # or null for default VPC
use_private_subnets = false
```

### EC2 Configuration
```hcl
instance_count = 2
instance_type = "t3.micro"
os_type = "ubuntu"  # or "amazon-linux"
key_name = "my-key-pair"
create_eip = true
```

## Required Variables

- `project_id`: Project identifier
- `project_name`: Project name for resource naming
- `key_name`: AWS key pair name

## Outputs

- `vpc_id`: VPC ID
- `instance_ids`: EC2 instance IDs
- `instance_public_ips`: Public IP addresses
- `security_group_id`: Security group ID

## Examples

See `examples/` directory for usage patterns and `terraform.tfvars.existing-vpc` for existing VPC configuration.

## Features

- **Dynamic AMI selection**: Latest Amazon Linux 2 or Ubuntu 22.04
- **Multi-region support**: Uses data sources for availability zones
- **Flexible networking**: New or existing VPC support
- **Security**: EBS encryption, restricted SSH access
- **Cost optimization**: Optional Elastic IPs, right-sized instances
