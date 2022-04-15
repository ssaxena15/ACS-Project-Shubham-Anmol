# aws_ec2 module: variables.tf

variable "public_subnet_1" {}

variable "public_subnet_2" {}
variable "private_subnet_1" {}
variable "availability_zones_1" {}

variable "availability_zones_2" {}
variable "prefix" {}

variable "allow_ssh_bastion" {}

variable "web_alb_sg" {}