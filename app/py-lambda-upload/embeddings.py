from langchain_aws import BedrockEmbeddings
from utils import logger
import boto3
import os 

EMBEDDING_MODEL_ID = os.environ["EMBEDDING_MODEL"]

bedrock_client = boto3.client(service_name="bedrock-runtime")

embeddings_model = BedrockEmbeddings(
    model_id=EMBEDDING_MODEL_ID,
    client=bedrock_client,
    region_name="eu-west-2",
)


def create_embeddings(page_texts: list[dict]) -> list[list[float]]:

    texts = [page["page_content"] for page in page_texts]

    logger.info(f"Generating embeddings for {len(texts)} pages")

    embeddings = embeddings_model.embed_documents(texts)

    logger.info(f"Generated {len(embeddings )} embeddings")

    return embeddings
