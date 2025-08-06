data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_lambda_function" "py_lambda_upload" {
  function_name = var.upload_lambda_function_name
}