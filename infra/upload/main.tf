data "archive_file" "py_lambda_upload" {
  type        = "zip"
  source_dir  = "${path.module}/../../app/upload"
  output_path = "${path.module}/../app/upload/upload.zip"
}


# # Lambda Function
resource "aws_lambda_function" "py_lambda_upload" {
  function_name    = "py-lambda-upload"
  description      = "This Lambda function generates a presigned URL that can be used to Upload S3 objects"
  role             = aws_iam_role.py_lambda_upload_execution_role.arn
  package_type     = "Zip"
  filename         = "${path.module}/../../app/upload/upload.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.py_lambda_upload.output_base64sha256
  timeout          = 30

}

# ## Lambda execution role 

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

# Policy to enable Lambda to generated S3 presigned urls 

data "aws_iam_policy_document" "py_lambda_upload_s3_url_policy_doc" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${data.aws_s3_bucket.upload_s3_bucket.arn}/upload/*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "py_lambda_upload_s3_presigned_url_policy" {
  name   = "py-lambda-upload-s3-presigned-url-policy"
  policy = data.aws_iam_policy_document.py_lambda_upload_s3_url_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "py_lambda_upload_s3_presigned_url_policy_attachment" {
  role       = aws_iam_role.py_lambda_upload_execution_role.name
  policy_arn = aws_iam_policy.py_lambda_upload_s3_presigned_url_policy.arn
}

