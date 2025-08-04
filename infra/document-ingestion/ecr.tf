resource "aws_ecr_repository" "py_lambda_upload" {
  name                 = "py-lambda-upload"
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "py_lambda_upload_repository_policy" {
  statement {
    sid    = "LambdaImagePull"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]
  }
}

resource "aws_ecr_repository_policy" "py_lambda_upload" {
  repository = aws_ecr_repository.py_lambda_upload.name
  policy     = data.aws_iam_policy_document.py_lambda_upload_repository_policy.json
}