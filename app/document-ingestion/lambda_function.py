from utils import logger, connect_to_db
from process_pdf import process_pdf
from embeddings import create_embeddings
from vector_db import insert_embeddings


def lambda_handler(event, context):

    try:
        logger.info("⚡ Lambda function started")

        bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
        object_key = event["Records"][0]["s3"]["object"]["key"]

        pdf = pdf_retrieval(bucket_name, object_key)

        embeddings = create_embeddings(pdf)

        logger.info(f"Created {len(embeddings)} of length {len(embeddings[0])}")

        with connect_to_db() as conn:
            insert_embeddings(conn, pdf, embeddings)

        return {"statusCode": 200, "body": f"✅ Embedded {len(embeddings)} documents"}

    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {"statusCode": 500, "body": f"Lambda failed: {str(e)}"}
