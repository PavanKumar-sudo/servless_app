from aws_lambda_powertools import Logger
import os
import boto3

logger = Logger()

@logger.inject_lambda_context
def lambda_handler(event, context):
    # ✅ Force 5xx simulation — only for testing
    if event.get("queryStringParameters", {}).get("force_error") == "true":
        raise Exception("Simulated 5xx error for alarm test")

    region = os.environ.get('AWS_REGION', 'us-east-1')
    table = boto3.resource('dynamodb', region_name=region).Table(
        os.environ['TABLE_NAME']
    )

    code = event['pathParameters']['code']
    logger.info({"action": "get_item", "code": code})

    response = table.get_item(Key={'code': code})

    if 'Item' in response:
        logger.info({"status": "found", "redirect_url": response['Item']['url']})
        return {
            "statusCode": 302,
            "headers": {"Location": response['Item']['url']}
        }
    else:
        logger.warning({"status": "not_found", "code": code})
        return {
            "statusCode": 404,
            "body": "Not found"
        }
