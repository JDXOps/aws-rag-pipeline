import logging
import json
import boto3
from botocore import ClientError
import psycopg

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_secret(secret_name: str):

    client = boto3.client("secretsmanager", region_name="eu-west-2")

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    secret = get_secret_value_response["SecretString"]

    return json.loads(secret)


POSTGRES_CRED = get_secret("law-pdf-demo-db")
POSTGRES_USER = POSTGRES_CRED["username"]
POSTGRES_PASS = POSTGRES_CRED.get("password")
POSTGRES_HOST = POSTGRES_CRED.get("host")


def connect_to_db(
    POSTGRES_USER: str = POSTGRES_USER,
    POSTGRES_PASSWORD: str = POSTGRES_PASS,
    POSTGRES_HOST: str = POSTGRES_HOST,
):
    
    conn = psycopg.connect(
        dbname="vecdb",
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        host=POSTGRES_HOST,
    )

    return conn


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
