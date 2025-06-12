import json
import os
import boto3
import uuid

table = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    body = json.loads(event['body'])
    code = str(uuid.uuid4())[:6]
    long_url = body['url']

    table.put_item(Item={'code': code, 'url': long_url})
    return {
        "statusCode": 200,
        "body": json.dumps({"short_url": f"https://{event['headers']['host']}/{code}"})
    }
