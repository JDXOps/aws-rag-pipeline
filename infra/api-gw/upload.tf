resource "aws_api_gateway_rest_api" "aws_rag_api_gw" {
  name               = "aws-rag-api-law-pdf-demo"
  description        = "API Gateway for the Law PDF demo (RAG)"
  binary_media_types = ["application/pdf"]
}

# get-presigned-url 

## /upload

resource "aws_api_gateway_resource" "aws_rag_api_gw_upload" {
  rest_api_id = aws_api_gateway_rest_api.aws_rag_api_gw.id
  parent_id   = aws_api_gateway_rest_api.aws_rag_api_gw.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "aws_rag_api_gw_upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.aws_rag_api_gw.id
  resource_id   = aws_api_gateway_resource.aws_rag_api_gw_upload.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "aws_rag_api_gw_upload" {
  rest_api_id             = aws_api_gateway_rest_api.aws_rag_api_gw.id
  resource_id             = aws_api_gateway_resource.aws_rag_api_gw_upload.id
  http_method             = aws_api_gateway_method.aws_rag_api_gw_upload_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.py_lambda_upload.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.py_lambda_upload.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.aws_rag_api_gw.execution_arn}/*/*"
}






resource "aws_api_gateway_deployment" "aws_rag_api_gw_deployment" {
    rest_api_id = aws_api_gateway_rest_api.aws_rag_api_gw.id


    depends_on = [
      aws_api_gateway_method.aws_rag_api_gw_retrieval_post,
      aws_api_gateway_integration.aws_rag_api_gw_retrieval,
      aws_api_gateway_integration.aws_rag_api_gw_upload,
      aws_api_gateway_method.aws_rag_api_gw_upload_post
    ]
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name           = "prod"
  rest_api_id          = aws_api_gateway_rest_api.aws_rag_api_gw.id
  deployment_id        = aws_api_gateway_deployment.aws_rag_api_gw_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.aws_rag_api_cwlg.arn
    format          = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"caller\":\"$context.identity.caller\",\"user\":\"$context.identity.user\",\"requestTime\":\"$context.requestTime\",\"httpMethod\":\"$context.httpMethod\",\"resourcePath\":\"$context.resourcePath\",\"status\":\"$context.status\",\"protocol\":\"$context.protocol\",\"responseLength\":\"$context.responseLength\"}"
  }

  variables = {
    log_level = "INFO"
  }
}
