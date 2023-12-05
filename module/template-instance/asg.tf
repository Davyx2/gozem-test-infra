resource "aws_autoscaling_group" "main" {
  name = "test-gozem-asg"

  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  termination_policies = [ "OldestLaunchTemplate" ]
  health_check_type    = var.health_check_type

  target_group_arns = [ aws_lb_target_group.main.arn ]
 
  launch_template {
    id = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }


  force_delete = false


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
