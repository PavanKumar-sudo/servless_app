import os
import boto3
import pytest
from moto import mock_dynamodb
from redirect import lambda_handler

@mock_dynamodb
def test_redirect_handler_found():
    os.environ['TABLE_NAME'] = 'short_urls'
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    
    table = dynamodb.create_table(
        TableName='short_urls',
        KeySchema=[{'AttributeName': 'code', 'KeyType': 'HASH'}],
        AttributeDefinitions=[{'AttributeName': 'code', 'AttributeType': 'S'}],
        BillingMode='PAY_PER_REQUEST'
    )
    table.put_item(Item={'code': 'abc123', 'url': 'https://example.com'})

    event = {
        'pathParameters': {'code': 'abc123'}
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 302
    assert response['headers']['Location'] == 'https://example.com'


@mock_dynamodb
def test_redirect_handler_not_found():
    os.environ['TABLE_NAME'] = 'short_urls'
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

    table = dynamodb.create_table(
        TableName='short_urls',
        KeySchema=[{'AttributeName': 'code', 'KeyType': 'HASH'}],
        AttributeDefinitions=[{'AttributeName': 'code', 'AttributeType': 'S'}],
        BillingMode='PAY_PER_REQUEST'
    )

    event = {
        'pathParameters': {'code': 'xyz999'}
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 404
    assert response['body'] == "Not found"
