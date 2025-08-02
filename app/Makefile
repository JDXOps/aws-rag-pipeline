public-login:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

ecr-login:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 005858686523.dkr.ecr.eu-west-2.amazonaws.com

upload-push:
	docker build -f ./py-lambda-upload/Dockerfile -t --platform linux/amd64 --provenance=false py-lambda-upload .
	docker tag py-lambda-upload:latest 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-upload:latest
	docker push 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-upload:latest

delete-upload: 
	aws s3 rm s3://law-pdf-demo/upload/prima_secure.pdf 
	aws s3 cp documents/prima_secure.pdf s3://law-pdf-demo/upload/

upload-lambda: 
	aws lambda update-function-code --function-name py-lambda-upload --image-uri 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-upload:latest

query-lambda: 
	aws lambda update-function-code --function-name py-lambda-upload --image-uri 005858686523.dkr.ecr.eu-west-2.amazonaws.com/py-lambda-query:latest

query-login: 
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 005858686523.dkr.ecr.eu-west-2.amazonaws.com