import json
import boto3
import os

dynamodb_client = boto3.resource('dynamodb')


def lambda_handler(event, context):
    item_id = event['pathParameters']['id']
    
    request_body = json.loads(event['body'])
    
    update_data = {
        'id': item_id,  
        'name': request_body.get('name'), 
        'surname': request_body.get('surname'),
        'city': request_body.get('city'),
        'age': request_body.get('age')
    }

    table = dynamodb_client.Table(os.environ['TableName'])
    
    try:
        response = table.get_item(Key={'id': item_id})
        if 'Item' not in response:
            return {
                'statusCode': 404,
                'body': json.dumps('Item not found')
            }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error checking item existence: {str(e)}')
        }
    
    try:
        response = table.put_item(Item=update_data)
        return {
            'statusCode': 200,
            'body': json.dumps('Item updated successfully')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error updating item: {str(e)}')
        }