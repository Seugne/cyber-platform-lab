# -----------------------------------------------------------------------------
# CloudGuard governance and observability variables
# -----------------------------------------------------------------------------

variable "cloudtrail_log_retention_days" {
  description = "Number of days CloudTrail events remain in CloudWatch Logs"
  type        = number
  default     = 30
  nullable    = false

  validation {
    condition = contains(
      [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365],
      var.cloudtrail_log_retention_days
    )
    error_message = "CloudTrail CloudWatch retention must use a supported retention period."
  }
}

variable "audit_log_expiration_days" {
  description = "Number of days before audit log objects expire from S3"
  type        = number
  default     = 365
  nullable    = false

  validation {
    condition     = var.audit_log_expiration_days >= 90
    error_message = "Audit logs must be retained in S3 for at least 90 days."
  }
}

variable "audit_noncurrent_version_expiration_days" {
  description = "Number of days before noncurrent audit object versions expire"
  type        = number
  default     = 90
  nullable    = false

  validation {
    condition     = var.audit_noncurrent_version_expiration_days >= 30
    error_message = "Noncurrent audit object versions must be retained for at least 30 days."
  }
}

variable "enable_cloudtrail_cloudwatch_logs" {
  description = "Whether CloudTrail also publishes management events to CloudWatch Logs"
  type        = bool
  default     = true
  nullable    = false
}

variable "enable_aws_config" {
  description = "Whether AWS Config records supported resource configuration changes"
  type        = bool
  default     = true
  nullable    = false
}
