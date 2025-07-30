from langchain_aws import BedrockEmbeddings, ChatBedrock
from langchain.prompts import PromptTemplate
from utils import connect_to_db, get_llm, get_llm_response

PROMPT_TEMPLATE = """
### Context
You are a legal assistant at a UK based law firm that specialises in contract law with the niche being employment contracts.  You assist legal teams by analysing legal documents and providing accurate, well reasoned responses.

### Objective
Your job is to answer user questions based on selected excerpts (chunks) from legal documents.  These chunks were retrieved via a similarity search and contain the most relevant content.

### Style
Be professional, concise, and clear. Avoid legal jargon where possible and do not overcomplicate the explanation.  

### Source Chunks
{document_chunks}

### Tone
Speak like a knowledgeable paralegal: direct, factual, and businesslike.

### Audience
Law firm employees ranging from junior associates to senior partners.

### Instructions
1. Review **all** of the provided chunks carefully.
1. Only use the provided chunks to answer the question — **do not make assumptions or use outside knowledge**.  
3. If multiple chunks provide similar information, choose the most accurate or authoritative phrasing. Do not refer to chunk numbers or locations — just include the relevant information naturally.
4. Your final output must be in the following JSON format:

{{
  "query": "{question}",
  "answer": "<insert final answer based only on the chunks>"
}}
5. Do not reference or mention "chunk numbers", "sections", or any metadata from the documents. Just deliver the answer.

"""

def answer_query(question:str, region:str="eu-west-2",aws_profile:str="default", top_k: int = 3, prompt_template:str=PROMPT_TEMPLATE):

    # Get embeddings model and create embeding vector from query for the similarity search
    embeddings_model = BedrockEmbeddings(model_id="amazon.titan-embed-text-v2:0", credentials_profile_name=aws_profile, region_name = region)
    embedding_vector = embeddings_model.embed_query(question)

    ## Similarity search for K nearest docs 

    conn = connect_to_db()

    with conn.cursor() as cur:
        cur.execute("""
            SELECT content, 1 - (embedding <=> %s::vector) AS score
            FROM documents
            ORDER BY embedding <=> %s::vector
            LIMIT %s;
        """, (embedding_vector, embedding_vector, top_k))

        results = cur.fetchall()

    conn.close()
    
    ## K nearest results
    formatted_results = [{"content": r[0], "score": r[1]} for r in results]

    ## Create Prompt 

    prompt = PromptTemplate(
        input_variables =  ["document_chunks","question"],
        template = prompt_template
    ).format(document_chunks = "\n\n".join([r["content"] for r in formatted_results]), question = question)

    llm = get_llm("anthropic.claude-3-7-sonnet-20250219-v1:0","eu-west-2",)

    llm_response = get_llm_response(llm,prompt)
    return llm_response

answer = answer_query("What is the probationary period?")

print(answer.content)
