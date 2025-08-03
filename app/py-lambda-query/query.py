from utils import get_llm, get_llm_response
import boto3
from langchain_aws import BedrockEmbeddings
import os
from langchain.prompts import PromptTemplate

EMBEDDING_MODEL_ID = os.environ["EMBEDDING_MODEL"]


def similarity_search(connection, query: str, k: int) -> list[tuple]:

    bedrock_client = boto3.client(service_name="bedrock-runtime")

    embeddings_model = BedrockEmbeddings(
        model_id=EMBEDDING_MODEL_ID,
        client=bedrock_client,
        region_name="eu-west-2",
    )

    query_vector = embeddings_model.embed_query(query)

    with connection as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT document, 1 - (embedding <=> %s::vector) AS score
                FROM documents
                ORDER BY embedding <=> %s::vector
                LIMIT %s;
            """,
                (query_vector, query_vector, k),
            )

            results = cur.fetchall()

    formatted_results = [{"content": r[0], "score": r[1]} for r in results]

    return formatted_results


def summarisation(
    documents: list[dict],
    prompt_template: str,
    question: str,
    summarisation_model_id: str,
):

    prompt = PromptTemplate(
        input_variables=["document_chunks", "question"], template=prompt_template
    ).format(
        document_chunks="\n\n".join([r["content"] for r in documents]),
        question=question,
    )

    llm = get_llm(summarisation_model_id, region="eu-west-2")

    response = get_llm_response(llm, prompt)

    return response
