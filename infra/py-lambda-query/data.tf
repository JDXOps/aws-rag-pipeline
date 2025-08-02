data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_bedrock_foundation_model" "summarisation_model" {
  model_id = var.summarisation_model
}

data "aws_bedrock_foundation_model" "embedding_model" {
  model_id = var.embedding_model
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.db_identifier
}