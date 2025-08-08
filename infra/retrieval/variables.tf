variable "db_url" {
  description = "The URL of the RDS Postgres Instance."
  type        = string
  default     = "terraform-20250801140632557400000001.cla62wuicb6s.eu-west-2.rds.amazonaws.com:5432"
}

variable "db_identifier" {
  description = "The DB Identifier of the RDS Postgres Instance."
  type        = string
  default     = "terraform-20250806134718913600000001"
}

variable "summarisation_model" {
  description = "The ID of the Bedrock Language Model that will be used to generate user responses"
  type        = string
  default     = "anthropic.claude-3-7-sonnet-20250219-v1:0"
}

variable "embedding_model" {
  description = "The ID of the Bedrock Language Model that will be used to generate vector embeddings"
  type        = string
  default     = "amazon.titan-embed-text-v2:0"
}