variable "upload_lambda_function_name" {
    type = string 
    description = "The name of the AWS Lambda function that handles uploads."
    default = "py-lambda-upload"
}