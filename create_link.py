from aws_lambda_powertools import Logger
import os
import boto3
import json
import uuid

logger = Logger()


@logger.inject_lambda_context
def lambda_handler(event, context):
    table_name = os.environ['TABLE_NAME']
    region = os.environ.get('AWS_REGION', 'us-east-1')
    table = boto3.resource('dynamodb', region_name=region).Table(table_name)

    try:
        if event.get("queryStringParameters", {}).get("force_error") == "true":
            raise Exception("Forced error for 5xx simulation")

        body = json.loads(event.get('body', '{}'))
        long_url = body.get('url')

        if not long_url:
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": "Missing 'url' in request body"
                })
            }

        code = str(uuid.uuid4())[:6].lower()
        logger.info({
            "action": "put_item",
            "code": code,
            "url": long_url
        })

        table.put_item(Item={'code': code, 'url': long_url})

        short_url = f"https://{event['headers']['host']}/{code}"
        return {
            "statusCode": 200,
            "body": json.dumps({"short_url": short_url})
        }

    except Exception as e:
        logger.error(f"Error processing request: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Internal Server Error"
            })
        }
