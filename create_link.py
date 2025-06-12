import os
import boto3
import json
import uuid


def lambda_handler(event, context):
    table_name = os.environ['TABLE_NAME']
    region = os.environ.get('AWS_REGION', 'us-east-1')

    table = boto3.resource(
        'dynamodb',
        region_name=region
    ).Table(table_name)

    body = json.loads(event['body'])
    code = str(uuid.uuid4())[:6]
    long_url = body['url']

    table.put_item(Item={'code': code, 'url': long_url})

    short_url = f"https://{event['headers']['host']}/{code}"
    return {
        "statusCode": 200,
        "body": json.dumps({"short_url": short_url})
    }
