# Default tags
variable "region" {}

variable "default_tags" {
  default = {
    "Owner" = "Shubham",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Group8-ShubhamAnmol"
  description = "Name prefix"
}


# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24","10.100.2.0/24", "10.100.3.0/24"]	# Dev
  #default     = ["10.200.1.0/24","10.200.2.0/24", "10.200.3.0/24"]	# Staging
  #default     = ["10.30.1.0/24","10.30.2.0/24", "10.30.3.0/24"]	# Prod
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidr" {
  default     = ["10.100.4.0/24","10.100.5.0/24", "10.100.6.0/24"]	# Dev
  #default     = ["10.200.4.0/24","10.200.5.0/24", "10.200.6.0/24"]	# Staging
  #default     = ["10.30.4.0/24","10.30.5.0/24", "10.30.6.0/24"]	# Prod
  type        = list(string)
  description = "Private Subnet CIDR"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"	# Dev
  #default     = "10.200.0.0/16"	# Staging
  #default     = "10.30.0.0/16"	# Prod
  type        = string
  description = "VPC Network"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  #default     = "staging"
  #default     = "prod"
  type        = string
  description = "Development Environment"
}

