import os
import json
import boto3
import pytest
from moto import mock_dynamodb
from lambda_function import lambda_handler  # adjust if your file name is different

TABLE_NAME = "UrlTable"

@pytest.fixture
def dynamodb_mock():
    with mock_dynamodb():
        # Set environment variable
        os.environ['TABLE_NAME'] = TABLE_NAME
        os.environ['AWS_REGION'] = 'us-east-1'

        # Create mock table
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        table = dynamodb.create_table(
            TableName=TABLE_NAME,
            KeySchema=[{'AttributeName': 'code', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'code', 'AttributeType': 'S'}],
            BillingMode='PAY_PER_REQUEST'
        )
        table.meta.client.get_waiter('table_exists').wait(TableName=TABLE_NAME)
        yield

def test_lambda_handler_success(dynamodb_mock):
    event = {
        "headers": {"host": "example.com"},
        "body": json.dumps({"url": "https://openai.com"})
    }
    response = lambda_handler(event, None)
    body = json.loads(response['body'])

    assert response['statusCode'] == 200
    assert 'short_url' in body
    assert body['short_url'].startswith("https://example.com/")

def test_lambda_handler_missing_url(dynamodb_mock):
    event = {
        "headers": {"host": "example.com"},
        "body": json.dumps({})
    }
    response = lambda_handler(event, None)
    assert response['statusCode'] == 400
    assert json.loads(response['body'])['error'] == "Missing 'url' in request body"
