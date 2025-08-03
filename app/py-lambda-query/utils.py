import logging
import boto3
import json
from botocore.exceptions import ClientError
import psycopg
import os
from langchain_aws import ChatBedrock

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def get_secret(secret_name: str):

    client = boto3.client("secretsmanager", region_name="eu-west-2")

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        raise e

    secret = get_secret_value_response["SecretString"]

    return json.loads(secret)


POSTGRES_CRED = get_secret("law-pdf-demo-db")
POSTGRES_USER = POSTGRES_CRED["username"]
POSTGRES_PASS = POSTGRES_CRED.get("password")
POSTGRES_HOST = os.environ["POSTGRES_HOST"]
SUMMARISATION_MODEL_ID = os.environ["SUMMARISATION_MODEL"]


def connect_to_db():

    try:
        conn = psycopg.connect(
            dbname="vecdb",
            user=POSTGRES_USER,
            password=POSTGRES_PASS,
            host=POSTGRES_HOST,
            port=5432,
        )
        logger.info("✅ Successfully connected to the database.")
        return conn
    except Exception as e:
        logger.error(f"❌ Failed to connect to the database: {e}")
        raise


PROMPT_TEMPLATE = """
### Context
You are a legal assistant at a UK based law firm that specialises in contract law with the niche being employment contracts.  You assist legal teams by analysing legal documents and providing accurate, well reasoned responses.

### Objective
Your job is to answer user questions based on selected excerpts (chunks) from legal documents.  These chunks were retrieved via a similarity search and contain the most relevant content.

### Style
Be professional, concise, and clear. Avoid legal jargon where possible and do not overcomplicate the explanation.  

### Source Chunks
{document_chunks}

### Tone
Speak like a knowledgeable paralegal: direct, factual, and businesslike.

### Audience
Law firm employees ranging from junior associates to senior partners.

### Instructions
1. Review **all** of the provided chunks carefully.
1. Only use the provided chunks to answer the question — **do not make assumptions or use outside knowledge**.  
3. If multiple chunks provide similar information, choose the most accurate or authoritative phrasing. Do not refer to chunk numbers or locations — just include the relevant information naturally.
4. Your final output must be in the following JSON format:

{{
  "query": "{question}",
  "answer": "<insert final answer based only on the chunks>"
}}
5. Do not reference or mention "chunk numbers", "sections", or any metadata from the documents. Just deliver the answer.

"""


def get_llm(model_id: str, region: str):

    return ChatBedrock(
        model_id=model_id,
        region_name=region,
    )


def get_llm_response(llm, prompt: str):
    response = llm.invoke(prompt)
    return response.content
