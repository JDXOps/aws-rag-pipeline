import logging
import boto3
import json
from botocore.exceptions import ClientError
import psycopg
import os


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
