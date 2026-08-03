# -----------------------------------------------------------------------------
# IAM outputs
# -----------------------------------------------------------------------------

output "app_ec2_role_arn" {
  description = "ARN of the CloudGuard application EC2 IAM role"
  value       = var.enable_compute ? aws_iam_role.app_ec2[0].arn : null
}

output "admin_ssm_role_arn" {
  description = "ARN of the CloudGuard administration SSM IAM role"
  value       = var.enable_compute ? aws_iam_role.admin_ssm[0].arn : null
}

output "app_instance_profile_name" {
  description = "Name of the application EC2 instance profile"
  value       = var.enable_compute ? aws_iam_instance_profile.app_ec2[0].name : null
}

output "admin_instance_profile_name" {
  description = "Name of the administration EC2 instance profile"
  value       = var.enable_compute ? aws_iam_instance_profile.admin_ssm[0].name : null
}

# -----------------------------------------------------------------------------
# KMS outputs
# -----------------------------------------------------------------------------

output "kms_key_id" {
  description = "ID of the CloudGuard customer-managed KMS key"
  value       = aws_kms_key.cloudguard.key_id
}

output "kms_key_arn" {
  description = "ARN of the CloudGuard customer-managed KMS key"
  value       = aws_kms_key.cloudguard.arn
}

output "kms_alias_name" {
  description = "Alias of the CloudGuard customer-managed KMS key"
  value       = aws_kms_alias.cloudguard.name
}

# -----------------------------------------------------------------------------
# EC2 outputs
# -----------------------------------------------------------------------------

output "app_instance_id" {
  description = "ID of the CloudGuard application EC2 instance"
  value       = var.enable_compute ? aws_instance.app[0].id : null
}

output "app_private_ip" {
  description = "Private IPv4 address of the CloudGuard application instance"
  value       = var.enable_compute ? aws_instance.app[0].private_ip : null
}

output "admin_instance_id" {
  description = "ID of the CloudGuard administration EC2 instance"
  value       = var.enable_compute ? aws_instance.admin[0].id : null
}

output "admin_private_ip" {
  description = "Private IPv4 address of the CloudGuard administration instance"
  value       = var.enable_compute ? aws_instance.admin[0].private_ip : null
}
