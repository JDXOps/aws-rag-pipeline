# Lambda Function
resource "aws_lambda_function" "py_lambda_doc_ingestion" {
  function_name = "py-lambda-doc-ingestion"
  description   = "This Lambda function converts PDFs into vectors that will be stored in a vector database."
  role          = aws_iam_role.py_lambda_doc_ingestion_execution_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.py_lambda_doc_ingestion.repository_url}:latest"
  timeout       = 120

  environment {
    variables = {
      POSTGRES_CREDS_NAME = "law-pdf-demo-db"
      POSTGRES_HOST       = aws_db_instance.default.address
      EMBEDDING_MODEL     = var.embedding_model
    }
  }
}

## Lambda execution role 

resource "aws_iam_role" "py_lambda_doc_ingestion_execution_role" {
  name               = "py-lambda-doc-ingestion-execution-role"
  assume_role_policy = data.aws_iam_policy_document.py_lambda_doc_ingestion_assume_role_policy.json
}

data "aws_iam_policy_document" "py_lambda_doc_ingestion_assume_role_policy" {
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

resource "aws_cloudwatch_log_group" "py_lambda_doc_ingestion" {
  name              = "/aws/lambda/${aws_lambda_function.py_lambda_doc_ingestion.function_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "py_lambda_doc_ingestion_cloudwatch_policy_doc" {
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
    resources = ["${aws_cloudwatch_log_group.py_lambda_doc_ingestion.arn}:*"]
  }
}

resource "aws_iam_policy" "py_lambda_doc_ingestion_cloudwatch_policy" {
  name   = "py-lambda-doc-ingestion-cloudwatch-policy"
  policy = data.aws_iam_policy_document.py_lambda_doc_ingestion_cloudwatch_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "py_lambda_doc_ingestion_cloudwatch_policy_attachment" {
  role       = aws_iam_role.py_lambda_doc_ingestion_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_doc_ingestion_cloudwatch_policy.arn
}

## Lambda S3 Trigger on Document doc_ingestion

data "aws_iam_policy_document" "py_lambda_doc_ingestion_s3_trigger_policy_doc" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/upload/*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "py_lambda_doc_ingestion_s3_trigger_policy" {
  name   = "py-lambda-doc-ingestion-s3-trigger-policy"
  policy = data.aws_iam_policy_document.py_lambda_doc_ingestion_s3_trigger_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_doc_ingestion_s3_trigger_policy_attachment" {
  role       = aws_iam_role.py_lambda_doc_ingestion_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_doc_ingestion_s3_trigger_policy.arn
}


## Bedrock IAM policy

data "aws_iam_policy_document" "py_lambda_doc_ingestion_bedrock_policy_document" {
  version = "2012-10-17"

  statement {
    sid    = "AllowInference"
    effect = "Allow"

    actions = [
      "bedrock:InvokeModel",
    ]

    resources = [data.aws_bedrock_foundation_model.titan_embeddings_model.model_arn]
  }
}

resource "aws_iam_policy" "py_lambda_doc_ingestion_bedrock_policy" {
  name   = "py-lamba-doc-ingestion-bedrock-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_doc_ingestion_bedrock_policy_document.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_doc_ingestion_bedrock_policy_attachment" {
  role       = aws_iam_role.py_lambda_doc_ingestion_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_doc_ingestion_bedrock_policy.arn
}

## Secrets Manager Policy

data "aws_iam_policy_document" "py_lambda_doc_ingestion_secrets_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"] ## Restrict Later
  }
}

resource "aws_iam_policy" "py_lambda_doc_ingestion_secrets_policy" {
  name   = "py-lambda-doc-ingestion-secrets-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_doc_ingestion_secrets_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_doc_ingestion_secrets_policy_attachment" {
  role       = aws_iam_role.py_lambda_doc_ingestion_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_doc_ingestion_secrets_policy.arn
}

