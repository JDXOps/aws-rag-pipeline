data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_bedrock_foundation_model" "claude_sonnet_llm" {
  model_id = "anthropic.claude-3-7-sonnet-20250219-v1:0"
}

