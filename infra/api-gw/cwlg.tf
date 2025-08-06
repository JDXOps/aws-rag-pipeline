data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "api_gateway_role" {
  name               = "aws-rag-api-gw-law-pdf-role"
  managed_policy_arns = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_api_gateway_account" "api_gateway_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_role.arn
}


resource "aws_cloudwatch_log_group" "aws_rag_api_cwlg" {
  name              = "API-Gateway-Execution-Logs/prod"
  retention_in_days = 7
}

