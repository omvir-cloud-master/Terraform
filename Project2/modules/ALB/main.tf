#######################################
# Application Load Balancer
#######################################

resource "aws_lb" "alb" {
  name               = "alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.security_group_id]
  subnets         = var.public_subnet_ids

  tags = {
    Name = "alb-${var.environment}"
  }
}

#######################################
# Target Group
#######################################

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "frontend-tg-${var.environment}"
  }
}

#######################################
# Attach EC2 Instances
#######################################

resource "aws_lb_target_group_attachment" "frontend" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}

#######################################
# Listener
#######################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}