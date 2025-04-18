# This Lambda function is triggered by an S3 event when a new image is uploaded.
# It uses AWS Rekognition to detect labels in the image and stores the results in DynamoDB.
# Use boto3 which is an AWS SDK for Python to interact with AWS services

import boto3

def lambda_handler(event, context):
    rekognition = boto3.client('rekognition')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('ImageResults')

    # Extract S3 bucket/key from the event trigger
    s3_info = event['Records'][0]['s3']
    bucket = s3_info['bucket']['name']
    key = s3_info['object']['key']

    # Call Rekognition to detect labels
    response = rekognition.detect_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': key}},
        MaxLabels=10  # Adjust based on needs
    )

    # Save results to DynamoDB
    table.put_item(Item={
        'image_name': key,
        'labels': [{'Name': label['Name'], 'Confidence': label['Confidence']} for label in response['Labels']]
    })

    return {'statusCode': 200}