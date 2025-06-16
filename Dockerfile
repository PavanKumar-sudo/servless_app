# Stage 1: Build Lambda with dependencies
FROM public.ecr.aws/lambda/python:3.12 AS builder

WORKDIR /app

ARG FUNCTION_FILE=create_link.py
ARG ZIP_NAME=create_link.zip

# Copy function file and requirements.txt
COPY ${FUNCTION_FILE} .
COPY requirements.txt .

# Install dependencies if requirements.txt is not empty
RUN if [ -s requirements.txt ]; then \
  pip install -r requirements.txt -t .; \
  fi

# Stage 2: Create the zip file
FROM alpine:3.17

RUN apk add --no-cache zip
WORKDIR /app

COPY --from=builder /app /app

# Create the zip package
RUN zip -r /${ZIP_NAME} .
