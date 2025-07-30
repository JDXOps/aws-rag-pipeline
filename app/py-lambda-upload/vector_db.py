from utils import logger
import json


def insert_embeddings(
    connection, texts: list[dict], embeddings: list[list[float]]
) -> int:

    inserted_count = 0
    with connection:
        with connection.cursor() as cursor:
            for text, embedding in zip(texts, embeddings):
                content = text["page_content"]
                metadata = text["metadata"]

                try:
                    cursor.execute(
                        """
                        INSERT INTO documents (content, embedding, metadata)
                        VALUES (%s, %s, %s)
                        """,
                        (content, embedding, json.dumps(metadata)),
                    )

                    inserted_count += 1

                except Exception as e:
                    logger.error(
                        f"❌ Insert failed for page {text.get('metadata', {}).get('page', 'unknown')}: {e}"
                    )

    logger.info(
        f"✅ Successfully inserted {inserted_count} documents into the database."
    )
    return inserted_count
