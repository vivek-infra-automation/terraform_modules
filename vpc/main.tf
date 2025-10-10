resource "aws_vpc" "main" {
  count                = var.vpc_count
  cidr_block           = var.vpc_configs[count.index].cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      Name = "${var.project_id}-${var.environment}-${var.vpc_configs[count.index].name}"
    },
    var.tags,
  )
}

resource "aws_internet_gateway" "igw" {
  count  = var.vpc_count
  vpc_id = aws_vpc.main[count.index].id

  tags = {
    Name = "${var.project_id}-${var.environment}-${var.vpc_configs[count.index].name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  count  = var.vpc_count
  vpc_id = aws_vpc.main[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }
  tags = {
    Name = "${var.project_id}-${var.environment}-${var.vpc_configs[count.index].name}-public-rt"
  }
}

locals {
  public_subnets = flatten([
    for vpc_idx, vpc in var.vpc_configs : [
      for subnet_idx, subnet in vpc.public_subnets : {
        vpc_index    = vpc_idx
        subnet_index = subnet_idx
        cidr_block   = subnet
        vpc_name     = vpc.name
      }
    ]
  ])
}

resource "aws_subnet" "public" {
  count                   = length(local.public_subnets)
  vpc_id                  = aws_vpc.main[local.public_subnets[count.index].vpc_index].id
  cidr_block              = local.public_subnets[count.index].cidr_block
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = "${var.project_id}-${var.environment}-${local.public_subnets[count.index].vpc_name}-public-${local.public_subnets[count.index].subnet_index + 1}"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(local.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt[local.public_subnets[count.index].vpc_index].id
}

locals {
  private_subnets = flatten([
    for vpc_idx, vpc in var.vpc_configs : [
      for subnet_idx, subnet in vpc.private_subnets : {
        vpc_index          = vpc_idx
        subnet_index       = subnet_idx
        cidr_block         = subnet
        vpc_name           = vpc.name
        enable_nat_gateway = vpc.enable_nat_gateway
      }
    ]
  ])
  
  nat_subnets = [for subnet in local.private_subnets : subnet if subnet.enable_nat_gateway]
}

resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.main[local.private_subnets[count.index].vpc_index].id
  cidr_block        = local.private_subnets[count.index].cidr_block
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = "${var.project_id}-${var.environment}-${local.private_subnets[count.index].vpc_name}-private-${local.private_subnets[count.index].subnet_index + 1}"
  }
}

resource "aws_eip" "nat" {
  count      = length(local.nat_subnets)
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count         = length(local.nat_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(local.public_subnets)].id

  tags = {
    Name = "${var.project_id}-${var.environment}-${local.nat_subnets[count.index].vpc_name}-nat-${local.nat_subnets[count.index].subnet_index + 1}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  count  = length(local.private_subnets)
  vpc_id = aws_vpc.main[local.private_subnets[count.index].vpc_index].id

  dynamic "route" {
    for_each = local.private_subnets[count.index].enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[index([for s in local.nat_subnets : "${s.vpc_index}-${s.subnet_index}"], "${local.private_subnets[count.index].vpc_index}-${local.private_subnets[count.index].subnet_index}")].id
    }
  }
  tags = {
    Name = "${var.project_id}-${var.environment}-${local.private_subnets[count.index].vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(local.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}


# VPC Endpoints
resource "aws_vpc_endpoint" "endpoints" {
  count           = length(var.vpc_endpoints)
  vpc_id          = aws_vpc.main[var.vpc_endpoints[count.index].vpc_index].id
  service_name    = var.vpc_endpoints[count.index].service_name
  vpc_endpoint_type = var.vpc_endpoints[count.index].type
  
  subnet_ids = var.vpc_endpoints[count.index].type == "Interface" ? [
    for subnet in aws_subnet.private : subnet.id 
    if subnet.vpc_id == aws_vpc.main[var.vpc_endpoints[count.index].vpc_index].id
  ] : null
  
  route_table_ids = var.vpc_endpoints[count.index].type == "Gateway" ? [
    for rt in aws_route_table.private_rt : rt.id 
    if rt.vpc_id == aws_vpc.main[var.vpc_endpoints[count.index].vpc_index].id
  ] : null

  tags = {
    Name = "${var.project_id}-${var.environment}-${var.vpc_configs[var.vpc_endpoints[count.index].vpc_index].name}-endpoint-${count.index}"
  }
}