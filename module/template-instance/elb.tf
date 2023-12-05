resource "aws_lb" "main" {
  name               = var.elb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-elb.id]
  
  subnets = var.public-subnet-for-instance
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.elb-incomming-port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
  depends_on = [ aws_lb.main ]
}

 resource "aws_lb_cookie_stickiness_policy" "main" {
  name                     = "alb-sticky-cookie-policy"
  load_balancer            = aws_lb.main.name
  lb_port                  = 80
  cookie_expiration_period = 600
  depends_on = [ aws_lb_listener.main ]
} 