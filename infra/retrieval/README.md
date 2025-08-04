## 🔍 RETRIEVAL PIPELINE (RAG)

This OpenTofu Infrastructure module provisions the infrastructure required to implement the query phase of a Retrieval-Augmented Generation (RAG) system. It enables semantic search over previously embedded documents using vector similarity and generates responses via a language model.

This module is designed to complement the ingestion pipeline by embedding user queries, retrieving relevant document chunks from a vector database, and invoking a model to generate final responses.

# ☁️ Powered by AWS

This module leverages a suite of AWS services to power the retrieval and generation workflow:

- Amazon Bedrock (Titan Embeddings) – to embed user queries into vectors
- Amazon RDS (PostgreSQL with PGVector) is where  document embeddings are retrieved from 
- Amazon Bedrock (Claude) to generate natural language responses using retrieved chunks
- AWS Lambda to handle the retrieval and response generation logic.
    
🧠 The retrieval pipeline is serverless and event-driven, offering efficient, on-demand compute. As with ingestion, RDS PostgreSQL with PGVector is the only non-serverless component and runs with fixed compute capacity.


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.py_lambda_query](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.py_lambda_query](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.py_lambda_query](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy.py_lambda_query_bedrock_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.py_lambda_query_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.py_lambda_query_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.py_lambda_query_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.py_lambda_query_bedrock_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.py_lambda_query_cloudwatch_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.py_lambda_query_secrets_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.py_lambda_query](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_bedrock_foundation_model.embedding_model](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/bedrock_foundation_model) | data source |
| [aws_bedrock_foundation_model.summarisation_model](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/bedrock_foundation_model) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_db_instance.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance) | data source |
| [aws_iam_policy_document.py_lambda_query_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_query_bedrock_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_query_cloudwatch_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_query_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_query_secrets_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_identifier"></a> [db\_identifier](#input\_db\_identifier) | The DB Identifier of the RDS Postgres Instance. | `string` | `"terraform-20250802102541446400000001"` | no |
| <a name="input_db_url"></a> [db\_url](#input\_db\_url) | The URL of the RDS Postgres Instance. | `string` | `"terraform-20250801140632557400000001.cla62wuicb6s.eu-west-2.rds.amazonaws.com:5432"` | no |
| <a name="input_embedding_model"></a> [embedding\_model](#input\_embedding\_model) | The ID of the Bedrock Language Model that will be used to generate vector embeddings | `string` | `"amazon.titan-embed-text-v2:0"` | no |
| <a name="input_summarisation_model"></a> [summarisation\_model](#input\_summarisation\_model) | The ID of the Bedrock Language Model that will be used to generate user responses | `string` | `"anthropic.claude-3-7-sonnet-20250219-v1:0"` | no |

## Outputs

No outputs.
