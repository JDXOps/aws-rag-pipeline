from utils import logger, connect_to_db
from query import similarity_search, summarisation
from utils import PROMPT_TEMPLATE, SUMMARISATION_MODEL_ID


def lambda_handler(event, context):

    logger.info(event)

    try:
        logger.info("⚡ Lambda function started")
        QUERY = event.get("query")
        conn = connect_to_db()
        results = similarity_search(conn, QUERY, 3)
        logger.info(f"Extracted {len(results)} from Postgres db")
        answer = summarisation(results, PROMPT_TEMPLATE, QUERY, SUMMARISATION_MODEL_ID)

        return answer

    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {"statusCode": 500, "body": f"Lambda failed: {str(e)}"}
