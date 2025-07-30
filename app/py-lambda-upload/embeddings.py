from langchain_aws import BedrockEmbeddings
from utils import logger
import boto3

bedrock_client = boto3.client(service_name="bedrock-runtime")

embeddings_model = BedrockEmbeddings(
    model_id="amazon.titan-embed-text-v2:0",
    client=bedrock_client,
    region_name="eu-west-2",
)


def create_embeddings(page_texts: list[dict]) -> list[list[float]]:

    texts = [page["page_content"] for page in page_texts]

    logger.info(f"Generating embeddings for {len(texts)} pages")

    embeddings = embeddings_model.embed_documents(texts)

    logger.info(f"Generated {len(embeddings )} embeddings")

    return embeddings
