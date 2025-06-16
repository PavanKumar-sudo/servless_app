from aws_lambda_powertools import Logger
import os
import boto3
import json
import uuid

# Instantiate Powertools logger
logger = Logger()

@logger.inject_lambda_context
def lambda_handler(event, context):
    table_name = os.environ['TABLE_NAME']
    region = os.environ.get('AWS_REGION', 'us-east-1')

    # DynamoDB table resource
    table = boto3.resource('dynamodb', region_name=region).Table(table_name)

    # Parse input
    body = json.loads(event['body'])
    code = str(uuid.uuid4())[:6]
    long_url = body['url']

    # Log event
    logger.info({"action": "put_item", "code": code, "url": long_url})

    # Store in DynamoDB
    table.put_item(Item={'code': code, 'url': long_url})

    # Build and return short URL
    short_url = f"https://{event['headers']['host']}/{code}"
    return {
        "statusCode": 200,
        "body": json.dumps({"short_url": short_url})
    }
