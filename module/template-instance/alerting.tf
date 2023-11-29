
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
  ok_actions = [ aws_sns_topic.instance.arn ]
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
  ok_actions = [ aws_sns_topic.instance.arn ]
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.main_policy_up.arn,
                    aws_sns_topic.instance.arn
  ]
}

resource "aws_sns_topic" "instance" {
  name = var.instance-topic-name
}

resource "aws_sns_topic" "application" {
  name = "topic-aplication"
}

resource "aws_sns_topic_subscription" "application" {
  topic_arn = aws_sns_topic.application.arn
  protocol = var.protocol
  endpoint = var.email
}

resource "aws_sns_topic_subscription" "instance" {
  topic_arn = aws_sns_topic.instance.arn
  protocol  = var.protocol
  endpoint  = var.email
}
###################

## System and Instance check
resource "aws_cloudwatch_metric_alarm" "main_systeme_instance" {
  alarm_name = "web_systeme_instance_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "StatusCheckFailed"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Maximum"
  threshold = "1"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name 
  }
  ok_actions = [ aws_sns_topic.instance.arn ]
  alarm_description = "This alarm helps to monitor both system status checks and instance status checks. If either type of status check fails, then this alarm should be in ALARM state."
  alarm_actions = [ aws_sns_topic.instance.arn ]
}
#healthy host alarm
resource "aws_cloudwatch_metric_alarm" "health" {
  alarm_name          = "web_healthy_host"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Healthy host count for EC2 machine"
  alarm_actions       = [ aws_sns_topic.instance.arn ]
  ok_actions          = [ aws_sns_topic.instance.arn ]

  dimensions = {
    LoadBalancer = aws_elb.main.name
  }
}
## low latency application
resource "aws_cloudwatch_metric_alarm" "main_latency" {
  alarm_name = "web_clatency_application"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "Latency"
  namespace = "AWS/ApplicationELB"
  period = "60"
  statistic = "Average"
  threshold = "2"

  dimensions = {
    LoadBalancer = aws_elb.main.name
  }

  alarm_description = "Alarm when Latency exceeds 100s"
  alarm_actions = [ aws_sns_topic.application.arn ]
}

### ERROR 5xx

resource "aws_cloudwatch_metric_alarm" "main_error" {
  alarm_name = "web_error_code_cinqxx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "HTTPCode_ELB_5XX_Count"
  namespace = "AWS/ApplicationELB"
  period = "60"
  statistic = "Sum"
  unit = "Count"
  threshold = "10"

  dimensions = {
    LoadBalancer = aws_elb.main.name
  }

  alarm_description = "Alarm when detect error 5xx"
  alarm_actions = [ aws_sns_topic.application.arn ]
}

resource "aws_cloudwatch_metric_alarm" "main_error_in_app" {
  alarm_name                = "web_detect_or_app"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  alarm_actions             = [ aws_sns_topic.application.arn ]
  threshold                 = 10
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = [ aws_sns_topic.application.arn ]

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_elb.main.name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = aws_elb.main.name
      }
    }
  }
}

#instance 


# Define CloudWatch Alarms for ALB
# Alert if HTTP 4xx errors are more than threshold value
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "App1-ALB-HTTP-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "2" # "2"
  evaluation_periods  = "3" # "3"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "5"  # Update real-world value like 100, 200 etc
  treat_missing_data  = "missing"  
  dimensions = {
    LoadBalancer = aws_elb.main.name
  }
  alarm_description = "This metric monitors ALB HTTP 4xx errors and if they are above 100 in specified interval, it is going to send a notification email"
  ok_actions          = [aws_sns_topic.application.arn]  
  alarm_actions     = [aws_sns_topic.application.arn]
}
