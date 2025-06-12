module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
}

module "iam" {
  source             = "./modules/Iam"
  dynamodb_table_arn = module.dynamodb.table_arn
  role_name          = var.lambda_exec_role_name
}

module "lambda" {
  source       = "./modules/lambda"
  role_arn     = module.iam.role_arn
  table_name   = var.table_name
  runtime      = var.lambda_runtime
  function_zip = {
    create   = "${path.module}/create_link.zip"
    redirect = "${path.module}/redirect.zip"
  }
  handlers = {
    create   = "create_link.lambda_handler"
    redirect = "redirect.lambda_handler"
  }
  function_names = {
    create   = var.create_lambda_function_name
    redirect = var.redirect_lambda_function_name
  }
}

module "apigateway" {
  source               = "./modules/apigateway"
  api_name             = var.api_gateway_name
  create_lambda_arn    = module.lambda.lambda_arns["create"]
  redirect_lambda_arn  = module.lambda.lambda_arns["redirect"]
  create_lambda_name   = var.create_lambda_function_name
  redirect_lambda_name = var.redirect_lambda_function_name
}
