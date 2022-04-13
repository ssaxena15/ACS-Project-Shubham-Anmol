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
  
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidr" {
  default     = ["10.100.4.0/24","10.100.5.0/24", "10.100.6.0/24"]	# Dev
  
  type        = list(string)
  description = "Private Subnet CIDR"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"	# Dev
  
  type        = string
  description = "VPC Network"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  
  type        = string
  description = "Development Environment"
}

