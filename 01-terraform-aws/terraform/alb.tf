# -----------------------------------------------------------------------------
# CloudGuard Application Load Balancer
#
# Public entry point:
# Internet -> HTTPS 443 -> ALB -> HTTP 8080 -> private EC2 application
#
# The HTTPS listener is created only when a valid ACM certificate ARN is
# supplied through var.acm_certificate_arn.
# -----------------------------------------------------------------------------

resource "aws_lb" "application" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = aws_subnet.public[*].id

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  drop_invalid_header_fields       = true
  enable_http2                     = true
  idle_timeout                     = 60

  tags = {
    Name = "${local.project_name}-alb"
    Role = "public-entry-point"
  }
}

# -----------------------------------------------------------------------------
# Application Target Group
# -----------------------------------------------------------------------------

resource "aws_lb_target_group" "application" {
  name        = "${local.project_name}-app-tg"
  port        = local.application_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.cloudguard.id

  deregistration_delay = 30

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/health"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${local.project_name}-app-tg"
    Role = "application"
  }
}

# -----------------------------------------------------------------------------
# Register the private application instance
# -----------------------------------------------------------------------------

resource "aws_lb_target_group_attachment" "application" {
  target_group_arn = aws_lb_target_group.application.arn
  target_id        = aws_instance.app.id
  port             = local.application_port
}

# -----------------------------------------------------------------------------
# HTTPS listener
#
# Count is zero until an ACM certificate ARN is provided.
# This prevents an insecure temporary HTTP listener from being deployed.
# -----------------------------------------------------------------------------

resource "aws_lb_listener" "https" {
  count = var.acm_certificate_arn == null ? 0 : 1

  load_balancer_arn = aws_lb.application.arn
  port              = local.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }

  tags = {
    Name = "${local.project_name}-listener-https"
    Role = "public-entry-point"
  }
}
