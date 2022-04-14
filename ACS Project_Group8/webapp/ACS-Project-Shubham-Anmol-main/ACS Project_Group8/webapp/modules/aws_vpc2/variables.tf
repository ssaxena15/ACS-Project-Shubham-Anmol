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

  default     = ["10.30.1.0/24","10.300.2.0/24", "10.300.3.0/24"]	# Prod
  
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_subnet_cidr" {
  
  default     = ["10.30.1.0/24","10.300.2.0/24", "10.300.3.0/24"]	# Prod
  type        = list(string)
  description = "Private Subnet CIDR"
}

# VPC CIDR range
variable "vpc_cidr" {
  
  default     = "10.30.0.0/16"	# Prod
  
  type        = string
  description = "VPC Network"
}

# Variable to signal the current environment 
variable "env" {
  #default     = "dev"
#default     = "staging"
  default     = "prod"
  
  type        = string
  description = "Development Environment"
}

