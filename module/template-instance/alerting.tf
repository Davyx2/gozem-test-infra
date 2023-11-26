
resource "aws_cloudwatch_metric_alarm" "main_cpu_alarm_down" {
  alarm_name = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.main.name}"
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.main_policy_down.arn,
                    aws_sns_topic.instance.arn
   ]
}

resource "aws_cloudwatch_metric_alarm" "main_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name 
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.main_policy_up.arn,
                    aws_sns_topic.instance.arn
  ]

}

resource "aws_sns_topic" "instance" {
  name = var.instance-topic-name
}

resource "aws_sns_topic_subscription" "instance" {
  topic_arn = aws_sns_topic.instance.arn
  protocol  = var.protocol
  endpoint  = var.email
}