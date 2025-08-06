import boto3
from utils import logger

s3_client = boto3.client("s3")

# 1mb = 1024 kilobytes, 1 kilobyte = 1024 bytes
MAX_FILE_SIZE = 20 * 1024 * 1024  # 20MB in bytes


def get_presigned_url(filename: str) -> dict:
    try:
        logger.info("Generating presigned URL")
        response = s3_client.generate_presigned_post(
            Bucket="law-pdf-demo",
            Key=f"upload/{filename}",
            Fields={"Content-Type": "application/pdf"},
            Conditions=[
                {"Content-Type": "application/pdf"},
                ["starts-with", "$key", "upload/"],
                ["content-length-range", 0, MAX_FILE_SIZE],
            ],
            ExpiresIn=300,
        )
        logger.info("Generated presigned URL")
        return {"success": True, "data": response}

    except Exception as e:
        logger.exception("Failed to generate pre-signed URL")
        return {"success": False, "error": str(e)}
