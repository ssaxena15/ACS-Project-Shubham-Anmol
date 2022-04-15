#output "web_lb_launch_config" {
#    value = aws_launch_configuration.web_lb_launch_config.id
#}

output "template_ami" {
    value = aws_ami_from_instance.web_template_ami.id
}