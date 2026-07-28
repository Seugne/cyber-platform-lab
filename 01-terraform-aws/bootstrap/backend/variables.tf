variable "aws_region" {
  description = "AWS region used for the Terraform backend."
  type        = string
  default     = "eu-west-3"

  validation {
    condition     = var.aws_region == "eu-west-3"
    error_message = "The CloudGuard laboratory backend must remain in eu-west-3."
  }
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "cloudguard"
}

variable "state_retention_days" {
  description = "Number of days before old non-current state versions are deleted."
  type        = number
  default     = 90

  validation {
    condition     = var.state_retention_days >= 30
    error_message = "State retention must be at least 30 days."
  }
}
