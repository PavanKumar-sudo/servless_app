import os
import boto3

def lambda_handler(event, context):
    table = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])

    code = event['pathParameters']['code']
    response = table.get_item(Key={'code': code})

    if 'Item' in response:
        return {
            "statusCode": 302,
            "headers": {"Location": response['Item']['url']}
        }
    else:
        return {
            "statusCode": 404,
            "body": "Not found"
        }
