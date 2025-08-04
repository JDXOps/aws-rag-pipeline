# 📄 DOCUMENT INGESTION INFRASTRUCTURE (RAG)

This OpenTofu Infrastructure module implements the ingestion phase of a Retrieval-Augmented Generation (RAG) system. It handles the ingestion of documents (PDFs), chunking of content, generation of vector embeddings, and storage of those embeddings in a vector database.

It leverages a suite of AWS Services to orchestrate the document ingestion and vectorisation pipeline: 

## ☁️ Powered by AWS

- Amazon Bedrock (Titan Embeddings) to generate vector embeddings from ingested PDFs.
- Amazon RDS (PostgreSQL with PGVector) to store vector embeddings
- Amazon S3 to store incoming PDF documents
- AWS Lambda orchestrate the chunking, embedding and summarization logic that is triggered by S3 upload events.

🧠 The ingestion pipeline is event-driven and mostly serverless, offering scalability and cost-efficiency. The only exception is RDS PostgreSQL with PGVector, which is provisioned with fixed compute capacity.


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.py_lambda_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_ecr_repository.py_lambda_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.py_lambda_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy.py_lambda_upload_bedrock_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.py_lambda_upload_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.py_lambda_upload_s3_trigger_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.py_lambda_upload_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.py_lambda_upload_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.py_lambda_upload_bedrock_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.py_lambda_upload_cloudwatch_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.py_lambda_upload_s3_trigger_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.py_lambda_upload_secrets_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.py_lambda_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.py_lamba_s3_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_object.upload_directory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_bedrock_foundation_model.titan_embeddings_model](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/bedrock_foundation_model) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.py_lambda_upload_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_upload_bedrock_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_upload_cloudwatch_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_upload_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_upload_s3_trigger_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.py_lambda_upload_secrets_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_subnet_cidrs"></a> [compute\_subnet\_cidrs](#input\_compute\_subnet\_cidrs) | n/a | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24"<br>]</pre> | no |
| <a name="input_data_subnet_cidrs"></a> [data\_subnet\_cidrs](#input\_data\_subnet\_cidrs) | n/a | `list(string)` | <pre>[<br>  "10.0.103.0/24",<br>  "10.0.104.0/24"<br>]</pre> | no |
| <a name="input_embedding_model"></a> [embedding\_model](#input\_embedding\_model) | The ID of the Bedrock Language Model that will be used to generate vector embeddings | `string` | `"amazon.titan-embed-text-v2:0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_url"></a> [db\_url](#output\_db\_url) | The URL of the RDS Postgres Instance. |
