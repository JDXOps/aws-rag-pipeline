import boto3
from datetime import datetime 
from dateutil.tz import tzutc
from io import BytesIO
from langchain.schema import Document

import pdfplumber

test = {'Records': [{'eventVersion': '2.1', 'eventSource': 'aws:s3', 'awsRegion': 'eu-west-2', 'eventTime': '2025-07-27T18:35:55.190Z', 'eventName': 'ObjectCreated:Put', 'userIdentity': {'principalId': 'AWS:AIDAQCXJUOY54TPRNTLZA'}, 'requestParameters': {'sourceIPAddress': '109.149.118.245'}, 'responseElements': {'x-amz-request-id': 'BNFB9QMQRE6HHWAR', 'x-amz-id-2': 'aBwBxu/gESzI74AhivR7Iz+fiyJNaP7kJvwPwafbaRY6XRUoxNhc0g+TInB2y4xzNOZmhHZ4xZnaXgPbE1IuZpX7EfZxexa91cwtUnHtOfM='}, 's3': {'s3SchemaVersion': '1.0', 'configurationId': 'tf-s3-lambda-20250727124248564900000001', 'bucket': {'name': 'law-pdf-demo', 'ownerIdentity': {'principalId': 'AMLE0LGQ883QL'}, 'arn': 'arn:aws:s3:::law-pdf-demo'}, 'object': {'key': 'upload/prima_secure.pdf', 'size': 179445, 'eTag': 'd3fb235de1adf1ba931e9adea89fb9b4', 'sequencer': '006886718B1294B591'}}}]}

# print(type(test["Records"]))
# print(len(test["Records"]))

# print(type(test["Records"][0]))
# print(list(test["Records"][0].keys()))


bucket_name = test["Records"][0]["s3"]["bucket"]["name"]
bucket_arn = test["Records"][0]["s3"]["bucket"]["arn"]
object_key = test["Records"][0]["s3"]["object"]["key"]
object_etag = test["Records"][0]["s3"]["object"]["eTag"]


# print(bucket_name, bucket_arn, object_key, object_etag)

s3_client = boto3.client("s3")
pdf_object = s3_client.get_object(
    Bucket = bucket_name, 
    Key = object_key
)

# PDFs are stored  in bytes on disk and in memory. BytesIO is ram based.  in this case s3.get_object is saving to RAM
pdf_bytes = pdf_object['Body'].read()

# BytesIO creates a replcia of the pdf stored in memory, because bytes are immutable, but BytesIO objects are mutable 
BytesIO(pdf_bytes)

page_texts = []

documents = []

with pdfplumber.open(BytesIO(pdf_bytes)) as pdf: 

    for i, page in enumerate(pdf.pages):
        page_num = i + 1 
        page_text = page.extract_text()


        page_texts.append(page_text)
        documents.append(Document(page_content = page_text, metadata = {"page": page_num} ))

# print(documents)

for page_text in page_texts: 
    print(len(page_text))
# print(type(documents[0]))
# print(documents[0].metadata)
