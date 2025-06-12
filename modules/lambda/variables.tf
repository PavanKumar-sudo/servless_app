variable "role_arn" {
  description = "The ARN of the IAM role for Lambda execution"
  type = string
  default     = "arn:aws:iam::123456789012:role/lambda_exec_role"
}

variable "runtime" {
  description = "The runtime environment for the Lambda functions"
  type = string
  default     = "python3.8"
}

variable "table_name" {
  description = "The name of the DynamoDB table to interact with"
  type = string
  default     = "my-dynamodb-table"
}

variable "function_zip" {
  description = "Map of Lambda function names to their zip file paths"
  type = map(string)
  default = {
    create   = "create_link.zip"
    redirect = "redirect.zip"
  }
}

variable "handlers" {
  description = "Map of Lambda function names to their handler functions"
  type = map(string)
  default = {
    create   = "create_link.lambda_handler"
    redirect = "redirect.lambda_handler"
  }
}

variable "function_names" {
  description = "Map of Lambda function names to their actual names"
  type = map(string)
  default = {
    create   = "CreateLinkFunction"
    redirect = "RedirectFunction"
  }
}
