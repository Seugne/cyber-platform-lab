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

output "security_group_ids" {
  description = "CloudGuard Security Group identifiers"
  value = {
    alb           = aws_security_group.alb.id
    app           = aws_security_group.app.id
    rds           = aws_security_group.rds.id
    admin         = aws_security_group.admin.id
    vpc_endpoints = aws_security_group.vpc_endpoints.id
  }
}

output "vpc_endpoint_ids" {
  description = "CloudGuard VPC Endpoint identifiers"
  value = {
    s3          = aws_vpc_endpoint.s3.id
    ssm         = aws_vpc_endpoint.ssm.id
    ssmmessages = aws_vpc_endpoint.ssmmessages.id
    ec2messages = aws_vpc_endpoint.ec2messages.id
  }
}
