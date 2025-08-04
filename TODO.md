## ✅ DONE
- [x] Amazon Titan Embeddings to produce vector embeddings
- [x] PGVector in Amazon RDS Postgres for a Vectorstore
- [x] AWS Lambda function for the document ingestion pipeline 
- [x] Lambda function for **user query handling**
- [x] Integrate Anthropic Claude (via Bedrock) to generate user facing responses from retrieved content.

## TODO:
- [ ] **API Gateway** for `/upload` and `/query` endpoints
- [ ] **Streamlit Frontend**
- [ ] Secure networking: **VPC, VPC Endpoints, Security Groups , WAF etc.**  
- [ ] **Lock down RDS** to internal VPC access only. 
- [ ] **Move Lambda functions to inside VPC** for secure communication with RDS. 
- [ ] **Utilise Jinja2 templates** for more better Prompt organisation and collaboration.
- [ ] Add environment variables where suitable

## SPIKE 

- [ ] Explore Lambda Cold Starts vs Fargate always on 
- [ ] Methodology to Track token usage