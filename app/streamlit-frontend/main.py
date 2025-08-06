import streamlit as st
import requests

API_GW_ENDPOINT = "https://92h875uadc.execute-api.eu-west-2.amazonaws.com/prod/upload"


st.title("Law PDF Demo RAG File Management")

uploaded_file = st.file_uploader("Choose a PDF to upload", type="pdf")


if uploaded_file is not None:
    st.success("File successfully uploaded to Streamlit!")

    st.write(f"Filename: {uploaded_file.name}")

    if st.button("Upload to S3"):

        payload = {"filename": uploaded_file.name, "content_type": uploaded_file.type}

        headers = {"Content-Type": "application/json"}

        response = requests.post(API_GW_ENDPOINT, json=payload, headers=headers)

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
