data "aws_s3_bucket" "upload_s3_bucket" {
  bucket = var.upload_s3_bucket_name
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}