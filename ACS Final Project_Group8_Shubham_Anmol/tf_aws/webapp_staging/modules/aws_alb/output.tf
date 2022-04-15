output "web_lb_url" {
    value = aws_lb.web_alb.dns_name
}

output "aws_lb_arn" {
    value = aws_lb.web_alb.arn
}