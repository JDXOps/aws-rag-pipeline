resource "aws_api_gateway_resource" "aws_rag_api_gw_retrieval" {
  rest_api_id = aws_api_gateway_rest_api.aws_rag_api_gw.id
  parent_id   = aws_api_gateway_rest_api.aws_rag_api_gw.root_resource_id
  path_part   = "query"
}

resource "aws_api_gateway_method" "aws_rag_api_gw_retrieval_post" {
  rest_api_id   = aws_api_gateway_rest_api.aws_rag_api_gw.id
  resource_id   = aws_api_gateway_resource.aws_rag_api_gw_retrieval.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "aws_rag_api_gw_retrieval" {
  rest_api_id             = aws_api_gateway_rest_api.aws_rag_api_gw.id
  resource_id             = aws_api_gateway_resource.aws_rag_api_gw_retrieval.id
  http_method             = aws_api_gateway_method.aws_rag_api_gw_retrieval_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.py_lambda_query.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_query_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.py_lambda_query.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.aws_rag_api_gw.execution_arn}/*/*"
}



