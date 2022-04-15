
output "allow_ssh_bastion" {
    value = aws_security_group.allow_ssh_bastion.id
}

output "web_alb_sg" {
    value = aws_security_group.web_alb_sg.id
}