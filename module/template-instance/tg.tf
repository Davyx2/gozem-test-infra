resource "aws_lb_target_group" "main" {
  name     = var.tg-name
  port     = var.tg-port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    enabled             = true
    port                = 8080 # nginx port
    interval            = 60
    protocol            = "HTTP"
    path                = "/healthy"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
