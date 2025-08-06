import boto3
from io import BytesIO
import pdfplumber
from utils import logger

s3_client = boto3.client("s3")


def process_pdf(bucket_name: str, object_key: str) -> list[dict]:

    logger.info("📄 Entered pdf_retrieval function!!!")  #

    try:

        logger.info(f"Fetching object: bucket={bucket_name}, key={object_key}")

        try:
            pdf_object = s3_client.get_object(Bucket=bucket_name, Key=object_key)
            logger.info("✅ S3 object fetched successfully")
        except Exception as e:
            logger.error(f"❌ Failed to fetch S3 object: {e}")
            raise

        pdf_bytes = pdf_object["Body"].read()

        logger.info("Read bytes from S3 body object")

        page_texts = []

        with pdfplumber.open(BytesIO(pdf_bytes)) as pdf:

            logger.info("Starting conversion of pdf pages into python dicts.")

            for i, page in enumerate(pdf.pages):
                page_num = i + 1
                page_text = page.extract_text()
                page_texts.append(
                    {"page_content": page_text, "metadata": {"page": page_num}}
                )

        logger.info(f"Generated {len(page_texts)} Python dicts.")

        return page_texts

    except Exception as e:
        return {"statusCode": 500, "body": f"Error retrieving object from S3: {str(e)}"}
