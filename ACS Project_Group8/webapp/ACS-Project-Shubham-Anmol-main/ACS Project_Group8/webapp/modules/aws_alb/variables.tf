variable "priv_subnet_ids" {
    type    = list(string)
}

variable "pub_subnet_ids" {
    type    = list(string)
}

variable "aws_vpc_id" {}

variable "web_alb_sg" {}

variable "web_alb_tg_arn" {}

#variable "web_lb_launch_config" {}

variable "template_ami" {}

variable "prefix" {}

variable "desired_count" {
    type = number
    default = 1
}

variable "min_count" {
    type = number
    default = 1
}
variable "max_count" {
    type = number
    default = 4
}
