output "vpc_ids" {
  value = aws_vpc.main[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "internet_gateway_ids" {
  value = aws_internet_gateway.igw[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "vpc_cidr_blocks" {
  value = aws_vpc.main[*].cidr_block
}

output "vpc_endpoint_ids" {
  value = aws_vpc_endpoint.endpoints[*].id
}
