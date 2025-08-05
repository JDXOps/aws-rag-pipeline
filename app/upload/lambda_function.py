from utils import logger
from get_presigned_url import get_presigned_url


def lambda_handler(event, context):

    try:

        filename = event["queryStringParameters"]["filename"]
        url = get_presigned_url(filename)
        return {"statusCode": 200, "body": url}

    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {"statusCode": 500, "body": f"Lambda failed: {str(e)}"}
