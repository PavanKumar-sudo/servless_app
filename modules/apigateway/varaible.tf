variable "api_name" {
  description = "The name of the API Gateway"
  type = string
  default     = "my-api-gateway"
}

variable "create_lambda_arn" {
  description = "The ARN of the Lambda function for creating links"
  type = string
  default     = "arn:aws:lambda:us-east-1:123456789012:function:create_link"
}

variable "redirect_lambda_arn" {
  description = "The ARN of the Lambda function for redirecting links"
  type = string
  default     = "arn:aws:lambda:us-east-1:123456789012:function:redirect_link"
}

variable "create_lambda_name" {
  type = string
  description = "Name of the create Lambda function (used for permissions)"
}

variable "redirect_lambda_name" {
  type = string
  description = "Name of the redirect Lambda function (used for permissions)"
}
