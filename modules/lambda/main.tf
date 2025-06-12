resource "aws_lambda_function" "lambda" {
  for_each = var.function_names

  function_name = each.value
  filename      = var.function_zip[each.key]
  handler       = var.handlers[each.key]
  runtime       = var.runtime
  role          = var.role_arn

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  depends_on = [var.role_arn]

  tags = {
    Environment = "Production"
    Project     = "URL Shortener"
  }
}
