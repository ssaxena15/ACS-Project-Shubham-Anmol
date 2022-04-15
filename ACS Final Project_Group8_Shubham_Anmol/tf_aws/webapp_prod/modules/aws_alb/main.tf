
resource "aws_lb" "web_alb" {
    name = "${var.prefix}-web-alb"
    # public facing
    internal = false
    # set to Application Load Balancer
    load_balancer_type = "application"
    security_groups = [var.web_alb_sg]
    #availability zone subnets.
    subnets = var.pub_subnet_ids
    tags = {
        Name = "${var.prefix}-load-balancer"
    }
}

# Launch template
resource "aws_launch_template" "ec2_template" {
    name_prefix   = "${var.prefix}-template"
    image_id      = var.template_ami
    instance_type = "t2.micro"

    network_interfaces {
      security_groups = [var.web_alb_sg]
      #associate_public_ip_address = true
      #subnet_id                   = var.priv_subnet_ids
      delete_on_termination       = true 
    }
}

# ALB Auto Scaling Group
resource "aws_autoscaling_group" "web_asgroup" {
    name = "${var.prefix}-alb-autoscaling-group"

    desired_capacity = var.desired_count
    min_size = var.min_count # minimum instance
    max_size = var.max_count # maximum instance
    health_check_type = "EC2"

    # delete without waiting
    force_delete = true

    #launch_configuration = var.web_lb_launch_config
    launch_template {
      id      = aws_launch_template.ec2_template.id
      version = "$Latest"
    }

    vpc_zone_identifier = var.priv_subnet_ids

    lifecycle {
        create_before_destroy = true # only create before other instance is destroyed
    }
}

# Attach load balancer to auto scaling group
resource "aws_autoscaling_attachment" "web_alb_as_attachment" {
    lb_target_group_arn = var.web_alb_tg_arn
    autoscaling_group_name = aws_autoscaling_group.web_asgroup.id
}

# Create dynamic scaling policy
resource "aws_autoscaling_policy" "alb_scale_out" {
    name = "web-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.web_asgroup.name
}

resource "aws_autoscaling_policy" "alb_scale_in" {
    name = "web-scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.web_asgroup.name
}

# Metric alarm for our dynamic scaling policy

# CPU metric for scale up
resource "aws_cloudwatch_metric_alarm" "alarm_scale_up" {
  alarm_description   = "CPU utilization for ASG"
  alarm_actions       = [aws_autoscaling_policy.alb_scale_out.arn]
  alarm_name          = "web_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asgroup.name
  }
}

# CPU metric for scale down
resource "aws_cloudwatch_metric_alarm" "alarm_scale_down" {
  alarm_description   = "CPU utilization for ASG"
  alarm_actions       = [aws_autoscaling_policy.alb_scale_in.arn]
  alarm_name          = "web_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asgroup.name
  }
}