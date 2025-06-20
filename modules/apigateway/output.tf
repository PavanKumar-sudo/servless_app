output "api_url" {
  description = "API Gateway Invoke URL"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.http_api.id
}

output "stage_name" {
  description = "API Gateway Stage Name"
  value       = aws_apigatewayv2_stage.default.name
}
