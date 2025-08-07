output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.aws_rag_api_gw.id}.execute-api.${data.aws_region.current.name}.amazonaws.com/prod"
}
