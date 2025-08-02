from utils import logger, connect_to_db
from query import similarity_search

def lambda_handler(event, context):

    logger.info(event)



    try:
        logger.info("⚡ Lambda function started")

        QUERY = event.get("query")

        conn = connect_to_db()

        results = similarity_search(conn, QUERY, 3)

        logger.info(f"Extracted {len(results)} from Postgres db")


    except Exception as e:
        logger.error(f"❌ Lambda failed: {e}")
        return {"statusCode": 500, "body": f"Lambda failed: {str(e)}"}
    

