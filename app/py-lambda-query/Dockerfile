FROM public.ecr.aws/lambda/python:3.13

# Root path for Lambda Function
COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip3 install -r requirements.txt

COPY . ${LAMBDA_TASK_ROOT}

CMD ["lambda_function.lambda_handler"]