# 🧱 AWS RAG Pipeline

This project is a work in progress **Retrieval-Augmented Generation (RAG)** pipeline whose purpose is to answer questions about Legal Documents. 


### 📐 Architecture 

- **AWS RDS Postgres** with `pgvector` for the Vector Store
- **AWS Bedrock** to access foundation models (Titan and Claude)
- **AWS Lambda** functions for serverless compute (document ingestion and retrieval)
- **Langchain** for orchestrating LLM workflows

### Project Structure 

- This project contains Infrastructue as Code with `OpenTofu` to generate all of the supporting AWS Infrastructure and application code in Python to orchestrate the RAG pipeline. 

```
.
├── README.md               # Project overview and documentation
├── TODO.md                 # Task tracking and roadmap
├── app/                    # Core application code (Lambda functions, RAG logic)
│   ├── document-ingestion/ # Ingestion pipeline  (PDFs → embeddings) 
│   ├── retrieval/          # Retrieval pipeline AWS Lambda function (PDFs → embeddings)     
├──infra/                   # OpenTofu Infrastructure as Code (IaC) modules 
│   ├── document-ingestion/ # Ingestion pipeline IaC (PDFs → embeddings) 
│   ├── retrieval/          # Query-time vector search and generation
└── scripts/                # Utility scripts for local dev, deployment, etc.
```

## 🛠 Stack
- Python 3.10+
- AWS Bedrock (Titan + Claude)
- PostgreSQL + pgvector
- LangChain
- AWS Lambda
- Streamlit (planned)
