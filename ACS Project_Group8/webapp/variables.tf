variable "region" {
  default = "us-east-1"
  type = string
}
#variable "access_key" {}
#variable "secret_key" {}

# Default tags
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
  default     = "week6-prod"
  description = "Name prefix"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}


