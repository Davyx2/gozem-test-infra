resource "aws_elb" "main" {
  name = var.elb-name
  security_groups = [ aws_security_group.sg-elb.id ]
  subnets = var.public-subnet-for-instance

  cross_zone_load_balancing   = true

   health_check {
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 60
    interval = 120
    target = "HTTP:80/"
  } 
#api/tutorials
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
  
}

resource "aws_lb_cookie_stickiness_policy" "main" {
  name                     = "alb-sticky-cookie-policy"
  load_balancer            = aws_elb.main.id
  lb_port                  = 80
  cookie_expiration_period = 600
}