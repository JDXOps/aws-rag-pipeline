resource "aws_s3_bucket" "bucket" {
  bucket = "law-pdf-demo"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "upload_directory" {
  key                    = "upload/"
  bucket                 = aws_s3_bucket.bucket.id
  server_side_encryption = "aws:kms"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.py_lambda_upload.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "upload/"
  }
}

resource "aws_lambda_permission" "py_lamba_s3_trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.py_lambda_upload.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}