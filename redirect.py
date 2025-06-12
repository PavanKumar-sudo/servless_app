import os
import boto3


table = boto3.resource('dynamodb').Table(os.environ['TABLE_NAME'])


def lambda_handler(event, context):
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
