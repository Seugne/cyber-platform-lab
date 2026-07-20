# -----------------------------------------------------------------------------
# Application Load Balancer and RDS variables
# -----------------------------------------------------------------------------

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate used by the public HTTPS listener"
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.acm_certificate_arn == null ||
      can(regex(
        "^arn:aws:acm:eu-west-3:[0-9]{12}:certificate/[0-9a-fA-F-]+$",
        var.acm_certificate_arn
      ))
    )
    error_message = "The ACM certificate ARN must be a valid eu-west-3 ACM certificate ARN or null."
  }
}

variable "database_name" {
  description = "Initial PostgreSQL database name"
  type        = string
  default     = "cloudguard"
  nullable    = false

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,62}$", var.database_name))
    error_message = "The database name must begin with a letter and contain only letters, numbers, and underscores."
  }
}

variable "database_master_username" {
  description = "PostgreSQL master username; the password is managed by AWS Secrets Manager"
  type        = string
  default     = "cloudguard_admin"
  nullable    = false

  validation {
    condition = (
      can(regex("^[A-Za-z][A-Za-z0-9_]{0,62}$", var.database_master_username)) &&
      !contains(
        ["admin", "postgres", "root", "rdsadmin"],
        lower(var.database_master_username)
      )
    )
    error_message = "The database master username is invalid or uses a prohibited administrative name."
  }
}

variable "database_instance_class" {
  description = "RDS PostgreSQL instance class used by the CloudGuard laboratory"
  type        = string
  default     = "db.t3.micro"
  nullable    = false

  validation {
    condition = contains(
      ["db.t3.micro", "db.t3.small", "db.t4g.micro", "db.t4g.small"],
      var.database_instance_class
    )
    error_message = "The database instance class must be an approved laboratory class."
  }
}

variable "database_allocated_storage" {
  description = "Initial allocated RDS storage in GiB"
  type        = number
  default     = 20
  nullable    = false

  validation {
    condition = (
      var.database_allocated_storage >= 20 &&
      var.database_allocated_storage <= 100
    )
    error_message = "Initial RDS storage must be between 20 and 100 GiB."
  }
}

variable "database_max_allocated_storage" {
  description = "Maximum RDS storage in GiB when storage autoscaling is enabled"
  type        = number
  default     = 50
  nullable    = false

  validation {
    condition = (
      var.database_max_allocated_storage >= var.database_allocated_storage &&
      var.database_max_allocated_storage <= 200
    )
    error_message = "Maximum RDS storage must be at least the initial allocation and no more than 200 GiB."
  }
}

variable "database_backup_retention_days" {
  description = "Number of days for automated RDS backup retention"
  type        = number
  default     = 7
  nullable    = false

  validation {
    condition = (
      var.database_backup_retention_days >= 1 &&
      var.database_backup_retention_days <= 35
    )
    error_message = "RDS backup retention must be between 1 and 35 days."
  }
}

variable "database_multi_az" {
  description = "Whether to deploy the RDS instance using Multi-AZ"
  type        = bool
  default     = false
  nullable    = false
}

variable "database_deletion_protection" {
  description = "Whether RDS deletion protection is enabled"
  type        = bool
  default     = true
  nullable    = false
}
