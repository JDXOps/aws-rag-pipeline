data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_bedrock_foundation_model" "titan_embeddings_model" {
  model_id = var.embedding_model
}

