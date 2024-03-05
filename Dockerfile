# Use the provided base image
FROM public.ecr.aws/lambda/provided:al2023

RUN dnf install -y awscli

# Copy requirements.txt
COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN dnf install libglvnd-opengl libglvnd-glx python3-pip -y

# Install dependencies and the Lambda Runtime Interface Client
RUN pip install -r requirements.txt && \
    pip install awslambdaric

# Copy function code and entrypoint script
COPY lambda_function.py ${LAMBDA_TASK_ROOT}
COPY entrypoint.sh ${LAMBDA_TASK_ROOT}

# Make entrypoint script executable
RUN chmod +x entrypoint.sh

# Set the ENTRYPOINT to the custom entrypoint script
ENTRYPOINT [ "./entrypoint.sh" ]

# Set the CMD to the handler for your Lambda function
CMD [ "lambda_function.handler" ]


