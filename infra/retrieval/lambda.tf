# Lambda Function
resource "aws_lambda_function" "py_lambda_query" {
  function_name = "py-lambda-query"
  description   = "This Lambda function runs a similarity search for a RAG pipeline."
  role          = aws_iam_role.py_lambda_query_execution_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.py_lambda_query.repository_url}:latest"
  timeout       = 60

  environment {
    variables = {
      POSTGRES_CREDS_NAME = "law-pdf-demo-db"
      POSTGRES_HOST       = "data.aws_db_instance.database.address"
      EMBEDDING_MODEL     = var.embedding_model
      SUMMARISATION_MODEL = var.summarisation_model
    }
  }
}

resource "aws_iam_role" "py_lambda_query_execution_role" {
  name               = "py-lambda-query-execution-role"
  assume_role_policy = data.aws_iam_policy_document.py_lambda_query_assume_role_policy.json
}

## Lambda Execution Role

data "aws_iam_policy_document" "py_lambda_query_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

## CloudWatch Log Group 

resource "aws_cloudwatch_log_group" "py_lambda_query" {
  name              = "/aws/lambda/${aws_lambda_function.py_lambda_query.function_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "py_lambda_query_cloudwatch_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.py_lambda_query.arn}:*"]
  }
}

resource "aws_iam_policy" "py_lambda_query_cloudwatch_policy" {
  name   = "py-lambda-query-cloudwatch-policy"
  policy = data.aws_iam_policy_document.py_lambda_query_cloudwatch_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "py_lambda_query_cloudwatch_policy_attachment" {
  role       = aws_iam_role.py_lambda_query_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_query_cloudwatch_policy.arn
}

## Bedrock IAM policy

data "aws_iam_policy_document" "py_lambda_query_bedrock_policy_document" {
  version = "2012-10-17"

  statement {
    sid    = "AllowInference"
    effect = "Allow"

    actions = [
      "bedrock:InvokeModel",
    ]

    resources = [data.aws_bedrock_foundation_model.summarisation_model.model_arn, data.aws_bedrock_foundation_model.embedding_model.model_arn]
  }
}

resource "aws_iam_policy" "py_lambda_query_bedrock_policy" {
  name   = "py-lamba-query-bedrock-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_query_bedrock_policy_document.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_query_bedrock_policy_attachment" {
  role       = aws_iam_role.py_lambda_query_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_query_bedrock_policy.arn
}

## Secrets Manager Policy

data "aws_iam_policy_document" "py_lambda_query_secrets_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"] ## Restrict Later
  }
}

resource "aws_iam_policy" "py_lambda_query_secrets_policy" {
  name   = "py-lambda-query-secrets-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_query_secrets_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_query_secrets_policy_attachment" {
  role       = aws_iam_role.py_lambda_query_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_query_secrets_policy.arn
}

