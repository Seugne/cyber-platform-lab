variable "aws_region" {
  description = "AWS region used for CloudGuard"
  type        = string
  default     = "eu-west-3"
  nullable    = false

  validation {
    condition     = contains(["eu-west-3"], var.aws_region)
    error_message = "CloudGuard must be deployed in the approved AWS region: eu-west-3."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "lab"
  nullable    = false

  validation {
    condition = contains(
      ["lab", "staging", "production"],
      var.environment
    )
    error_message = "The environment must be one of: lab, staging, production."
  }
}

variable "vpc_cidr" {
  description = "CIDR block of the CloudGuard VPC"
  type        = string
  default     = "10.0.0.0/16"
  nullable    = false

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC CIDR must be a valid IPv4 or IPv6 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by CloudGuard"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
  nullable    = false

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "CloudGuard requires exactly two Availability Zones."
  }

  validation {
    condition     = length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "Availability Zones must not contain duplicate values."
  }

  validation {
    condition = alltrue([
      for az in var.availability_zones :
      contains(["eu-west-3a", "eu-west-3b"], az)
    ])
    error_message = "CloudGuard Availability Zones must be eu-west-3a and eu-west-3b."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  nullable    = false

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "The number of public subnet CIDRs must match the number of Availability Zones."
  }

  validation {
    condition     = length(distinct(var.public_subnet_cidrs)) == length(var.public_subnet_cidrs)
    error_message = "Public subnet CIDRs must not contain duplicate values."
  }

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "Every public subnet value must be a valid CIDR block."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
  nullable    = false

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "The number of private subnet CIDRs must match the number of Availability Zones."
  }

  validation {
    condition     = length(distinct(var.private_subnet_cidrs)) == length(var.private_subnet_cidrs)
    error_message = "Private subnet CIDRs must not contain duplicate values."
  }

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "Every private subnet value must be a valid CIDR block."
  }

  validation {
    condition = length(
      distinct(
        concat(
          var.public_subnet_cidrs,
          var.private_subnet_cidrs
        )
      )
      ) == (
      length(var.public_subnet_cidrs) +
      length(var.private_subnet_cidrs)
    )
    error_message = "Public and private subnet CIDR lists must not contain duplicate CIDR blocks."
  }
}
