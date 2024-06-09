import json
import boto3
import os

dynamodb_client = boto3.resource('dynamodb')

def lambda_handler(event, context):
    print(event)
    id = event['pathParameters']['id']
    table = dynamodb_client.Table(os.environ['TableName'])
    response = table.delete_item(
        Key={
            'id': id
        }
    )
    
    return {
        'statusCode': 204,
        'body': json.dumps('Object is deleted successfully'),
        "headers": {
            "Content-Type": "application/json"
        }
    }