# -----------------------------------------------------------------------------
# Compute variables
# -----------------------------------------------------------------------------

variable "app_instance_type" {
  description = "EC2 instance type used by the CloudGuard application server"
  type        = string
  default     = "t3.micro"
  nullable    = false

  validation {
    condition = contains(
      ["t3.micro", "t3.small"],
      var.app_instance_type
    )
    error_message = "The application instance type must be t3.micro or t3.small."
  }
}

variable "admin_instance_type" {
  description = "EC2 instance type used by the CloudGuard administration server"
  type        = string
  default     = "t3.micro"
  nullable    = false

  validation {
    condition = contains(
      ["t3.micro", "t3.small"],
      var.admin_instance_type
    )
    error_message = "The administration instance type must be t3.micro or t3.small."
  }
}

variable "app_root_volume_size" {
  description = "Size in GiB of the application EC2 root EBS volume"
  type        = number
  default     = 12
  nullable    = false

  validation {
    condition = (
      var.app_root_volume_size >= 8 &&
      var.app_root_volume_size <= 100
    )
    error_message = "The application root volume must be between 8 and 100 GiB."
  }
}

variable "admin_root_volume_size" {
  description = "Size in GiB of the administration EC2 root EBS volume"
  type        = number
  default     = 10
  nullable    = false

  validation {
    condition = (
      var.admin_root_volume_size >= 8 &&
      var.admin_root_volume_size <= 100
    )
    error_message = "The administration root volume must be between 8 and 100 GiB."
  }
}
