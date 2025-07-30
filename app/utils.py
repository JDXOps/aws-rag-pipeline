import os 
import psycopg2 
from dotenv import load_dotenv
from langchain_aws import ChatBedrock

load_dotenv()

POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_HOST=os.getenv("POSTGRES_HOST")
# OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

def connect_to_db(POSTGRES_USER:str=POSTGRES_USER,POSTGRES_PASSWORD:str=POSTGRES_PASSWORD, POSTGRES_HOST:str=POSTGRES_HOST):
    
    print(POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_HOST)
    
    conn = psycopg2.connect(
        dbname="postgres",
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        host=POSTGRES_HOST
    )

    return conn 

def get_llm(model_id:str, region:str, aws_profile:str="default"):

    return  ChatBedrock(
        model_id=model_id,
        region_name=region,  # adjust if needed
        credentials_profile_name=aws_profile
    )

def get_llm_response(llm,prompt:str): 
    return llm.invoke(prompt)
