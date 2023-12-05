resource "aws_sns_topic" "instance" {
  name = var.instance-topic-name
}

resource "aws_sns_topic" "application" {
  name = var.topic-app
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