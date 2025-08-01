import logging
import boto3
import json
from botocore.exceptions import ClientError
import psycopg2
import os


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
POSTGRES_HOST = os.environ["POSTGRES_HOST"]


def connect_to_db():

    logger.info("Starting DB Connection")
    logger.info(f"Using psycopg2 version: {psycopg2.__version__}")


    try:
        conn = psycopg2.connect(
            dbname="vecdb",
            user=POSTGRES_USER,
            password=POSTGRES_PASS,
            host="terraform-20250801140632557400000001.cla62wuicb6s.eu-west-2.rds.amazonaws.com",  ## somethign wrong with env? 
            port = 5432
        )
        logger.info("✅ Successfully connected to the database.")
        return conn
    except Exception as e:
        logger.error(f"❌ Failed to connect to the database: {e}")
        raise



