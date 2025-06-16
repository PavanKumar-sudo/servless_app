data "aws_caller_identity" "current" {}

# Create CloudWatch Log Group for API Access Logs
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/url-shortener-logs"
  retention_in_days = 7
}

# Create API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = "HTTP"
}

# Lambda Integration for Create
resource "aws_apigatewayv2_integration" "create" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.create_lambda_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Lambda Integration for Redirect
resource "aws_apigatewayv2_integration" "redirect" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.redirect_lambda_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

# Route for creating short URL
resource "aws_apigatewayv2_route" "shorten" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "POST /shorten"
  target             = "integrations/${aws_apigatewayv2_integration.create.id}"
  authorization_type = "NONE"
}

# Route for redirecting
resource "aws_apigatewayv2_route" "redirect" {
  api_id             = aws_apigatewayv2_api.http_api.id
  route_key          = "GET /{code}"
  target             = "integrations/${aws_apigatewayv2_integration.redirect.id}"
  authorization_type = "NONE"
}

# Enable $default Stage with access logs and detailed metrics
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    detailed_metrics_enabled = true
    logging_level            = "INFO"
    throttling_burst_limit   = 500
    throttling_rate_limit    = 100
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  depends_on = [aws_cloudwatch_log_group.api_logs]
}

# Lambda invoke permission for Create Lambda
resource "aws_lambda_permission" "create" {
  statement_id  = "AllowCreateInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.create_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Lambda invoke permission for Redirect Lambda
resource "aws_lambda_permission" "redirect" {
  statement_id  = "AllowRedirectInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.redirect_lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
