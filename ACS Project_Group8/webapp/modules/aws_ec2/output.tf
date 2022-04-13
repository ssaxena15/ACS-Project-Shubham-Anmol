

output "template_ami" {
    value = aws_ami_from_instance.web_template_ami.id
}