# tests/utils.py

class MockLambdaContext:
    function_name = "test_func"
    memory_limit_in_mb = 128
    invoked_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:test_func"
    aws_request_id = "test-request-id"
