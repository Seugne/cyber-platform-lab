# -----------------------------------------------------------------------------
# Central audit storage
# -----------------------------------------------------------------------------

output "audit_bucket_name" {
  description = "Name of the central CloudGuard audit bucket"
  value       = aws_s3_bucket.audit.id
}

output "audit_bucket_arn" {
  description = "ARN of the central CloudGuard audit bucket"
  value       = aws_s3_bucket.audit.arn
}

# -----------------------------------------------------------------------------
# CloudTrail
# -----------------------------------------------------------------------------

output "cloudtrail_name" {
  description = "Name of the CloudGuard multi-Region management trail"
  value       = aws_cloudtrail.management.name
}

output "cloudtrail_arn" {
  description = "ARN of the CloudGuard multi-Region management trail"
  value       = aws_cloudtrail.management.arn
}

output "cloudtrail_cloudwatch_log_group_name" {
  description = "CloudWatch Logs group receiving CloudTrail management events"
  value = try(
    aws_cloudwatch_log_group.cloudtrail[0].name,
    null
  )
}

# -----------------------------------------------------------------------------
# AWS Config
# -----------------------------------------------------------------------------

output "aws_config_enabled" {
  description = "Whether the AWS Config recorder is enabled"
  value       = var.enable_aws_config
}

output "aws_config_recorder_name" {
  description = "Name of the AWS Config recorder"
  value = try(
    aws_config_configuration_recorder.cloudguard[0].name,
    null
  )
}
