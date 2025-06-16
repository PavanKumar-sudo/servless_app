variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "The AWS region where resources will be deployed."
}
variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table to store short URL mappings."
}

variable "lambda_runtime" {
  type        = string
  description = "The runtime environment for Lambda functions."
}

variable "create_lambda_function_name" {
  type        = string
  description = "The name of the Lambda function for creating short URLs."
}

variable "redirect_lambda_function_name" {
  type        = string
  description = "The name of the Lambda function for handling redirection."
}

variable "api_gateway_name" {
  type        = string
  description = "The name of the API Gateway HTTP API."
}

variable "lambda_exec_role_name" {
  type        = string
  description = "The IAM role name assigned to Lambda functions."
}

variable "alert_email" {
  description = "Email to receive CloudWatch alerts"
  type        = string
}

