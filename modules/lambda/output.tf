output "lambda_arns" {
  description = "ARNs of the deployed Lambda functions"
  value = { for k, v in aws_lambda_function.lambda : k => v.invoke_arn }
}