resource "aws_autoscaling_policy" "main_policy_up" {
  name = var.asg-policy
  scaling_adjustment = var.scaling_adjustment
  adjustment_type = var.adjustment_type
  cooldown = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.main.name
}

resource "aws_autoscaling_policy" "main_policy_down" {
  name = "main_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.main.name
}




