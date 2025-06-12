variable "role_name" {
  description = "The name of the IAM role for Lambda execution"
  type = string
  default     = "lambda_exec_role"
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table to grant access to"
  type = string
  default     = "arn:aws:dynamodb:us-east-1:123456789012:table/my-dynamodb-table"
  

}