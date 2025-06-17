import os
import boto3


def lambda_handler(event, context):
    table_name = os.environ['TABLE_NAME']
    region = os.environ.get('AWS_REGION', 'us-east-1')
    table = boto3.resource('dynamodb', region_name=region).Table(table_name)

    code = event.get('pathParameters', {}).get('code')
    if not code:
        return {
            "statusCode": 400,
            "body": "Missing code"
        }

    try:
        response = table.get_item(Key={'code': code})
        item = response.get('Item')
        if item:
            return {
                "statusCode": 302,
                "headers": {
                    "Location": item['url']
                }
            }
        else:
            return {
                "statusCode": 404,
                "body": "Not found"
            }

    except Exception as e:
        print(f"Error fetching from DynamoDB: {e}")
        return {
            "statusCode": 500,
            "body": "Internal Server Error"
        }
