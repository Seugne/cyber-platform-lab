# -----------------------------------------------------------------------------
# CloudGuard feature flags
#
# These variables control optional infrastructure components without requiring
# changes to the Terraform source code.
#
# lab        : reduced-cost architecture for development and validation
# production : complete CloudGuard architecture
# -----------------------------------------------------------------------------

variable "enable_nat_gateway" {
  description = "Whether to create the NAT Gateway and private Internet routes"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_interface_endpoints" {
  description = "Whether to create the paid SSM interface VPC endpoints"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_compute" {
  description = "Whether to create the CloudGuard application and administration EC2 instances"
  type        = bool
  default     = false
  nullable    = false
}

variable "enable_alb" {
  description = "Whether to create the public Application Load Balancer and its related resources"
  type        = bool
  default     = false
  nullable    = false

  validation {
    condition     = !var.enable_alb || var.enable_compute
    error_message = "The Application Load Balancer requires enable_compute = true."
  }
}
