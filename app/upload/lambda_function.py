import json
from utils import logger
from get_presigned_url import get_presigned_url


def lambda_handler(event, context):

    try:
        body = json.loads(event.get("body") or "{}")
        filename = body["filename"]
        logger.info(f"📦 Incoming event: {filename}")
        url = get_presigned_url(filename)
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(url),
        }

    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }
