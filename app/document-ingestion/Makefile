public-login:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

ecr-login:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 005858686523.dkr.ecr.eu-west-2.amazonaws.com

build: 
	docker build -t py-lambda-doc-ingestion   --platform linux/amd64 --provenance=false .
	docker tag py-lambda-doc-ingestion:latest 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-doc-ingestion:latest

push:
	docker push 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-doc-ingestion:latest

update-lambda: 
	aws lambda update-function-code --function-name py-lambda-doc-ingestion --image-uri 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-doc-ingestion:latest