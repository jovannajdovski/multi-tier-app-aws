
resource "aws_alb" "main" {
    name        = "cb-load-balancer"
    subnets         = aws_subnet.public.*.id
    security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
    name        = "cb-target-group"
    port        = var.app_secure_port
    protocol    = "HTTPS"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.app]

  default_action {
    type = "redirect"
    redirect {
      port        = var.app_secure_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_secure_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  depends_on        = [aws_alb_target_group.app]

  default_action {
    target_group_arn = aws_alb_target_group.app.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_certificate" "https_additional_certs" {
  listener_arn    = aws_alb_listener.https.arn
  certificate_arn = aws_acm_certificate.cert.arn
}
