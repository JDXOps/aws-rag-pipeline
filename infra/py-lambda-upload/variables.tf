variable "compute_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.103.0/24", "10.0.104.0/24"]
}

variable "embedding_model" {
    description = "The ID of the Bedrock Language Model that will be used to generate vector embeddings"
    type = string 
    default = "amazon.titan-embed-text-v2:0"
}