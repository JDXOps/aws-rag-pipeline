import streamlit as st
import requests
from dotenv import load_dotenv
import os

load_dotenv()

API_GW_URL = os.environ.get("API_GW_URL")

API_GW_ENDPOINT_UPLOAD = f"{API_GW_URL}/upload"
API_GW_ENDPOINT_QUERY = f"{API_GW_URL}/query"



st.title("Law PDF Demo RAG File Management")

uploaded_file = st.file_uploader("Choose a PDF to upload", type="pdf")


if uploaded_file is not None:
    st.success("File successfully uploaded to Streamlit!")

    st.write(f"Filename: {uploaded_file.name}")

    if st.button("Upload to S3"):

        payload = {"filename": uploaded_file.name, "content_type": uploaded_file.type}


        headers = {"Content-Type": "application/json"}

        response = requests.post(API_GW_ENDPOINT_UPLOAD, json=payload, headers=headers)

        st.write("Presigned URL request status:", response.status_code)
        if response.status_code == 200:
            
            presigned = response.json()
            url = presigned["data"]["url"]
            fields = presigned["data"]["fields"]

            files = {"file": (uploaded_file.name, uploaded_file, uploaded_file.type)}
            upload_response = requests.post(url, data=fields, files=files)

            if upload_response.status_code == 204:
                st.success("✅ File uploaded successfully to S3!")
            else:
                st.error(
                    f"❌ Upload failed with status code {upload_response.status_code}"
                )
                st.text(upload_response.text)

        else:
            st.error("❌ Failed to get a presigned URL")
            st.text(response.text)


st.header("🔎 Search Uploaded Documents")

query = st.text_input("Ask a question or enter search text:")

if query:
    if st.button("Search"):
        with st.spinner("Searching..."):
           try:
                payload = {"query": query}
                headers = {"Content-Type": "application/json"}

                response = requests.post(API_GW_ENDPOINT_QUERY, json=payload, headers=headers)

                if response.status_code == 200:
                    results = response.json()
                    st.write("sucess")
            
           except Exception as e:
                st.error(f"Search failed: {e}")