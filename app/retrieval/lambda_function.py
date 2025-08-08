import json
from utils import logger, connect_to_db
from query import similarity_search, summarisation
from utils import PROMPT_TEMPLATE, SUMMARISATION_MODEL_ID


def lambda_handler(event, context):

    try:
        logger.info("⚡ Lambda function started")
        logger.info(event)
        body = json.loads(event.get("body"))
        query = body.get("query")

        conn = connect_to_db()
        results = similarity_search(conn, query, 3)
        logger.info(f"Extracted {len(results)} from Postgres db")
        answer = summarisation(results, PROMPT_TEMPLATE, query, SUMMARISATION_MODEL_ID)

        new_answer = json.dumps(answer)

        logger.info(type(new_answer))
        logger.info(new_answer)

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps(answer),
        }

    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": f"Lambda failed: {str(e)}"}),
        }
