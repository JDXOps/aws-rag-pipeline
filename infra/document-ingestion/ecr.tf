resource "aws_ecr_repository" "py_lambda_doc_ingestion" {
  name                 = "py-lambda-doc-ingestion"
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "py_lambda_doc_ingestion_repository_policy" {
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

resource "aws_ecr_repository_policy" "py_lambda_doc_ingestion" {
  repository = aws_ecr_repository.py_lambda_doc_ingestion.name
  policy     = data.aws_iam_policy_document.py_lambda_doc_ingestion_repository_policy.json
}