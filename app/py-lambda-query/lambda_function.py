from utils import logger, connect_to_db

def lambda_handler(event, context):
    try:
        logger.info("⚡ Lambda function started")


    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {"statusCode": 500, "body": f"Lambda failed: {str(e)}"}
