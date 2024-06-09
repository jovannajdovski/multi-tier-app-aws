import json
import boto3
import os

dynamodb_client = boto3.resource('dynamodb')

def lambda_handler(event, context):
    print(event)
    event=json.loads(event['body'])
    table = dynamodb_client.Table(os.environ['TableName'])
    
    id = event['id']
    name = event['name']
    surname = event['surname']
    city = event['city']
    age = event['age']

    item = {
        'id': str(id),
        'name': str(name),
        'surname': str(surname),
        'city': str(city),
        'age': str(age),
    }

    response = table.put_item(
        Item=item
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Object is added successfully'),
        "headers": {
            "Content-Type": "application/json"
        }
    }