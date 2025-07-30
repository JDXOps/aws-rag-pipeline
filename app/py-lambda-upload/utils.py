import logging
import boto3
import json
from botocore.exceptions import ClientError
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
