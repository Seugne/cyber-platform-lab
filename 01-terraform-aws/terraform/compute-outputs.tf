# -----------------------------------------------------------------------------
# IAM outputs
# -----------------------------------------------------------------------------

output "app_ec2_role_arn" {
  description = "ARN of the CloudGuard application EC2 IAM role"
  value       = aws_iam_role.app_ec2.arn
}

output "admin_ssm_role_arn" {
  description = "ARN of the CloudGuard administration SSM IAM role"
  value       = aws_iam_role.admin_ssm.arn
}

output "app_instance_profile_name" {
  description = "Name of the application EC2 instance profile"
  value       = aws_iam_instance_profile.app_ec2.name
}

output "admin_instance_profile_name" {
  description = "Name of the administration EC2 instance profile"
  value       = aws_iam_instance_profile.admin_ssm.name
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
  value       = aws_instance.app.id
}

output "app_private_ip" {
  description = "Private IPv4 address of the CloudGuard application instance"
  value       = aws_instance.app.private_ip
}

output "admin_instance_id" {
  description = "ID of the CloudGuard administration EC2 instance"
  value       = aws_instance.admin.id
}

output "admin_private_ip" {
  description = "Private IPv4 address of the CloudGuard administration instance"
  value       = aws_instance.admin.private_ip
}
