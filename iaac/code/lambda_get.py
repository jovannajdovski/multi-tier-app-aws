import json
import boto3
import os
from decimal import Decimal

dynamodb_client = boto3.resource('dynamodb')

def lambda_handler(event, context):
    print(event)
    id = event['pathParameters']['id']
    table = dynamodb_client.Table(os.environ['TableName'])
    response = table.get_item(
        Key={
            'id': id
        }
    )

    if 'Item' not in response:
        return {
            'statusCode': 404,
            'body': json.dumps({'error': 'Not Found'})
        }
    
    data = response['Item']
    
    for key, value in data.items():
        if isinstance(value, Decimal):
            data[key] = float(value)
        
    return {
        'statusCode': 200,
        'body': json.dumps(data)
    }
