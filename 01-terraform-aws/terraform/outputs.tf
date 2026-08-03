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
  value       = var.enable_nat_gateway ? aws_nat_gateway.nat_a[0].id : null
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
    vpc_endpoints = var.enable_interface_endpoints ? aws_security_group.vpc_endpoints[0].id : null
  }
}

output "vpc_endpoint_ids" {
  description = "CloudGuard VPC Endpoint identifiers"
  value = {
    s3          = aws_vpc_endpoint.s3.id
    ssm         = var.enable_interface_endpoints ? aws_vpc_endpoint.ssm[0].id : null
    ssmmessages = var.enable_interface_endpoints ? aws_vpc_endpoint.ssmmessages[0].id : null
    ec2messages = var.enable_interface_endpoints ? aws_vpc_endpoint.ec2messages[0].id : null
  }
}
