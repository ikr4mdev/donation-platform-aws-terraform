# ==============================================================
# LB
# ==============================================================

resource "aws_lb" "lb" {
  name               = "${terraform.workspace}-lb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2 = var.enable_http2

  tags = merge(
    {
        Name = "${terraform.workspace}-lb"
    },
    var.tags
  )
}

# ==============================================================
# NEXT JS TARGET GROUP
# ==============================================================

resource "aws_lb_target_group" "nextjs_tg" {
  name     = "${terraform.workspace}-nextjs-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  deregistration_delay = var.deregistration_delay

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(
    {
        Name = "${terraform.workspace}-nextjs-tg"
    },
    var.tags
  )
}

# ==============================================================
# ALB HTTP LISTENER
# ==============================================================

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nextjs_tg.arn
  }
}


# ==============================================================
# HTTPS LISTENER - FOR ACM LATER
# ==============================================================

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = var.ssl_policy
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nextjs_tg.arn
#   }
# }

# ============================================================
# HTTP → HTTPS REDIRECT
# ============================================================

# resource "aws_lb_listener" "http_to_https" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "redirect"
#     redirect {
#       port = "443"
#       protocol = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }