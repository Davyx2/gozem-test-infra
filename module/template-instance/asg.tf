resource "aws_autoscaling_group" "main" {
  name = "test-gozem-asg"

  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  
  health_check_type    = var.health_check_type
  load_balancers = [
    aws_elb.main.id 
  ]

  launch_configuration = aws_launch_configuration.main.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = var.metrics_granularity

  vpc_zone_identifier  = var.public-subnet-for-instance

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "main"
    propagate_at_launch = true
  }
}
