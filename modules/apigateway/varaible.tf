variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "create_lambda_arn" {
  description = "The ARN of the Lambda function for creating links"
  type        = string
}

variable "redirect_lambda_arn" {
  description = "The ARN of the Lambda function for redirecting links"
  type        = string
}

variable "create_lambda_name" {
  description = "The name of the Create Lambda function"
  type        = string
}

variable "redirect_lambda_name" {
  description = "The name of the Redirect Lambda function"
  type        = string
}
