# -----------------------------------------------------------------------------
# Application Load Balancer outputs
# -----------------------------------------------------------------------------

output "application_load_balancer_arn" {
  description = "ARN of the CloudGuard Application Load Balancer"
  value       = aws_lb.application.arn
}

output "application_load_balancer_dns_name" {
  description = "Public DNS name of the CloudGuard Application Load Balancer"
  value       = aws_lb.application.dns_name
}

output "application_target_group_arn" {
  description = "ARN of the CloudGuard application Target Group"
  value       = aws_lb_target_group.application.arn
}

output "https_listener_enabled" {
  description = "Whether the CloudGuard HTTPS listener is configured"
  value       = var.acm_certificate_arn != null
}

# -----------------------------------------------------------------------------
# RDS outputs
# -----------------------------------------------------------------------------

output "rds_instance_identifier" {
  description = "Identifier of the CloudGuard PostgreSQL instance"
  value       = aws_db_instance.postgresql.identifier
}

output "rds_endpoint" {
  description = "DNS endpoint of the CloudGuard PostgreSQL instance"
  value       = aws_db_instance.postgresql.address
}

output "rds_port" {
  description = "PostgreSQL port of the CloudGuard database"
  value       = aws_db_instance.postgresql.port
}

output "rds_master_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the RDS master credentials"
  value       = try(aws_db_instance.postgresql.master_user_secret[0].secret_arn, null)
  sensitive   = true
}

output "rds_monitoring_role_arn" {
  description = "ARN of the CloudGuard RDS Enhanced Monitoring role"
  value       = aws_iam_role.rds_monitoring.arn
}
