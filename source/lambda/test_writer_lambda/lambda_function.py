import os
import json
import logging
from botocore.exceptions import ClientError
import boto3
import uuid


logLevel = os.getenv("LOG_LEVEL", "ERROR").upper()
log   = logging.getLogger()
log.setLevel(logLevel)


def lambda_handler(event, context):
    status = 200
    message = 'successful'
    log.debug(event)

    fileCount = int(os.getenv('FILE_COUNT', 1))
    try:
        s3BucketName = os.environ['BUCKET_NAME']
    except KeyError:
        message = 'Cannot find BUCKET_NAME environment variable'
        log.error(message)
        status = 404
        return{
            'statusCode': status,
            'body': json.dumps(message)
        }

    for _ in range(fileCount):
        create_s3_object(s3BucketName)

    log.info(f"Wrote {fileCount} objects to {s3BucketName}")
    return{
        'statusCode': status,
        'body': json.dumps(message)
    }

    
def create_s3_object(bucket):
    """
    Generate an object with random name and write to s3 bucket
    """
    filename = str(uuid.uuid4())
    filedata = os.urandom(1024)

    s3_client = boto3.client('s3')
    try:
        log.debug(f"Write {filename} to {bucket}")
        response = s3_client.put_object(Bucket = bucket, Key = filename, Body = filedata)
    except ClientError as e:
        log.debug(f"PutObject failed {e['response']['Message']} ({e['response']['Code']})")



