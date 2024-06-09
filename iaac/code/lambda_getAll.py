import boto3
import json
import os
from decimal import Decimal

dynamodb_client = boto3.resource('dynamodb')

def lambda_handler(event, context):
    
    table = dynamodb_client.Table(os.environ['TableName'])
    
    all_items = []
    
    response = table.scan()
    all_items.extend(response['Items'])
    for item in all_items:
        for key, value in item.items():
            if isinstance(value, Decimal):
                item[key] = float(value)
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(all_items)
    }
