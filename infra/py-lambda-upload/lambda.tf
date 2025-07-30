# Lambda Function
resource "aws_lambda_function" "py_lambda_upload" {
  function_name = "py-lambda-upload"
  description   = "This Lambda function converts PDFs into vectors that will be stored in a vector database."
  role          = aws_iam_role.py_lambda_upload_execution_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.py_lambda_upload.repository_url}:latest"
  timeout       = 60

  environment {
    variables = {
      POSTGRES_CREDS_NAME = "law-pdf-demo-db"
      POSTGRES_HOST       = aws_db_instance.default.endpoint
    }
  }
}

## Lambda execution role 

resource "aws_iam_role" "py_lambda_upload_execution_role" {
  name               = "py-lambda-upload-execution-role"
  assume_role_policy = data.aws_iam_policy_document.py_lambda_upload_assume_role_policy.json
}

data "aws_iam_policy_document" "py_lambda_upload_assume_role_policy" {
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

resource "aws_cloudwatch_log_group" "py_lambda_upload" {
  name              = "/aws/lambda/${aws_lambda_function.py_lambda_upload.function_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "py_lambda_upload_cloudwatch_policy_doc" {
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
    resources = ["${aws_cloudwatch_log_group.py_lambda_upload.arn}:*"]
  }
}

resource "aws_iam_policy" "py_lambda_upload_cloudwatch_policy" {
  name   = "py-lambda-upload-cloudwatch-policy"
  policy = data.aws_iam_policy_document.py_lambda_upload_cloudwatch_policy_doc.json
}


resource "aws_iam_role_policy_attachment" "py_lambda_upload_cloudwatch_policy_attachment" {
  role       = aws_iam_role.py_lambda_upload_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_upload_cloudwatch_policy.arn
}

## Lambda S3 Trigger on Document Upload

data "aws_iam_policy_document" "py_lambda_upload_s3_trigger_policy_doc" {
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

resource "aws_iam_policy" "py_lambda_upload_s3_trigger_policy" {
  name   = "py-lambda-upload-s3-trigger-policy"
  policy = data.aws_iam_policy_document.py_lambda_upload_s3_trigger_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_upload_s3_trigger_policy_attachment" {
  role       = aws_iam_role.py_lambda_upload_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_upload_s3_trigger_policy.arn
}


## Bedrock IAM policy

data "aws_iam_policy_document" "py_lambda_upload_bedrock_policy_document" {
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

resource "aws_iam_policy" "py_lambda_upload_bedrock_policy" {
  name   = "py-lamba-upload-bedrock-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_upload_bedrock_policy_document.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_upload_bedrock_policy_attachment" {
  role       = aws_iam_role.py_lambda_upload_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_upload_bedrock_policy.arn
}

## Secrets Manager Policy

data "aws_iam_policy_document" "py_lambda_upload_secrets_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"] ## Restrict Later
  }
}

resource "aws_iam_policy" "py_lambda_upload_secrets_policy" {
  name   = "py-lambda-upload-secrets-iam-policy"
  policy = data.aws_iam_policy_document.py_lambda_upload_secrets_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_upload_secrets_policy_attachment" {
  role       = aws_iam_role.py_lambda_upload_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_upload_secrets_policy.arn
}

