
# Target group - forward the requests to the backend instance
resource "aws_lb_target_group" "web_alb_tg" {
    port = 80
    protocol = "HTTP"
    vpc_id = var.aws_vpc_id
    load_balancing_algorithm_type = "round_robin"
    deregistration_delay = 60
    stickiness {
        enabled = false
        type    = "lb_cookie"
        cookie_duration = 60
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        interval            = 30
        path                = "/"
        protocol            = "HTTP"
        matcher             = 200
        
    }
    tags = {
        Name = "${var.prefix}-target-group"
    }
}

# Setup our ALB listener
resource "aws_lb_listener" "web_alb_listener" {  
    #load_balancer_arn = aws_lb.web_alb.arn
    load_balancer_arn = var.aws_lb_arn
    port = 80  
    protocol = "HTTP"
    default_action {    
        target_group_arn = aws_lb_target_group.web_alb_tg.arn
        type = "forward"  
    }
    #default_action {
    #    type = "fixed-response"
    #    fixed_response {
    #        content_type = "text/plain"
    #        message_body = " Site Not Found"
    #        status_code  = "200"
    #    }
    #}
    tags = {
        Name = "${var.prefix}-lb-listener"
    }
}

#resource "aws_lb_listener_rule" "listener_rule" {

#  listener_arn = aws_lb_listener.web_alb_listener.id
#  priority     = 100

#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.web_alb_tg.arn
#  }

#  condition {
#    host_header {
#      values = ["*"]
#    }
#  }
#}
