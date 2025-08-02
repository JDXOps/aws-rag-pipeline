from utils import connect_to_db
import boto3 
from langchain_aws import BedrockEmbeddings
import os 

EMBEDDING_MODEL_ID = os.environ["EMBEDDING_MODEL"]

def similarity_search(connection, query: str,  k: int ) -> list[tuple]: 

    bedrock_client = boto3.client(service_name="bedrock-runtime")

    embeddings_model = BedrockEmbeddings(
        model_id=EMBEDDING_MODEL_ID,
        client=bedrock_client,
        region_name="eu-west-2",
    )

    query_vector = embeddings_model.embed_query(query)


    with connection as conn: 
        with conn.cursor() as cur: 
            cur.execute("""
                SELECT document, 1 - (embedding <=> %s::vector) AS score
                FROM documents
                ORDER BY embedding <=> %s::vector
                LIMIT %s;
            """, (query_vector, query_vector, k))

        results = cur.fetchall()
    
    return results 