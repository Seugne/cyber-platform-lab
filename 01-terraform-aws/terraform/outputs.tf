output "vpc_id" {
  description = "ID of the CloudGuard VPC"
  value       = aws_vpc.cloudguard.id
}

output "vpc_cidr" {
  description = "CIDR block of the CloudGuard VPC"
  value       = aws_vpc.cloudguard.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the CloudGuard public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the CloudGuard private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the CloudGuard Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the CloudGuard laboratory NAT Gateway"
  value       = aws_nat_gateway.nat_a.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = aws_route_table.private[*].id
}
