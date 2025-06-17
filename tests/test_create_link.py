import json
import os
import boto3
from moto import mock_dynamodb
from create_link import lambda_handler
from tests.utils import MockLambdaContext

@mock_dynamodb
def test_create_short_url():
    os.environ["TABLE_NAME"] = "short_urls"
    os.environ["AWS_REGION"] = "us-east-1"

    dynamodb = boto3.resource("dynamodb", region_name="us-east-1")
    table = dynamodb.create_table(
        TableName="short_urls",
        KeySchema=[{"AttributeName": "code", "KeyType": "HASH"}],
        AttributeDefinitions=[{"AttributeName": "code", "AttributeType": "S"}],
        BillingMode="PAY_PER_REQUEST"
    )
    table.wait_until_exists()

    event = {
        "body": json.dumps({"url": "https://example.com"}),
        "headers": {"host": "mockapi.execute-api.local"}
    }

    response = lambda_handler(event, MockLambdaContext())
    body = json.loads(response["body"])

    assert response["statusCode"] == 200
    assert "short_url" in body
    assert body["short_url"].startswith("https://mockapi.execute-api.local/")
    assert len(body["short_url"].split("/")[-1]) == 6
