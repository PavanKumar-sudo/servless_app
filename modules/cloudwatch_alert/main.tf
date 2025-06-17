resource "aws_sns_topic" "alert_topic" {
  name = "api-gateway-alerts"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "api_5xx_errors" {
  alarm_name          = "APIGateway-5xxErrors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5xx"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Triggers if more than 5 5xx errors occur in 1 minute"
  alarm_actions       = [aws_sns_topic.alert_topic.arn]

  dimensions = {
    ApiId    = var.api_id
    Method   = "POST"
    Resource = "/shorten"
    Stage    = var.api_stage
  }
}
