resource "aws_alb_target_group" "utc-target-group" {
  name             = "utc-target-group"
  protocol         = "HTTP"
  port             = 80
  vpc_id           = aws_vpc.utc-app.id
  protocol_version = "HTTP1"
  tags = {
    environment = var.environment
    team        = var.team
  }

  health_check {
    protocol = "HTTP"
    path     = "/"
  }
}

resource "aws_alb_target_group_attachment" "appserver0" {
  target_group_arn = aws_alb_target_group.utc-target-group.arn
  target_id        = aws_instance.app-server[0].id
  port             = 80
}

resource "aws_alb_target_group_attachment" "appserver1" {
  target_group_arn = aws_alb_target_group.utc-target-group.arn
  target_id        = aws_instance.app-server[1].id
  port             = 80
}

resource "aws_lb" "utc-app-alb" {
  name               = "utc-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  tags = {
    environment = var.environment
    team        = var.team
  }
}

resource "aws_lb_listener" "utc-alb-listener" {
  load_balancer_arn = aws_lb.utc-app-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.utc-target-group.arn
  }
}

resource "aws_lb_listener" "utc-alb-listener2" {
  load_balancer_arn = aws_lb.utc-app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}