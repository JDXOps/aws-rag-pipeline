from utils import PROMPT_TEMPLATE
from langchain.prompts import PromptTemplate
import os 


SUMMARISATION_MODEL_ID = os.environ["SUMMARISATION_MODEL"] ##  move to summarisation file

# def create_prompt(prompt_template:str):
#     prompt = PromptTemplate(
#         input_variables=["document_chunks", "question"], template=prompt_template
#     ).format(
#         document_chunks="\n\n".join([r["content"] for r in formatted_results]),
#         question=question,
#     )