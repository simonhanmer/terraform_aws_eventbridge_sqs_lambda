import os
import json
import logging
import botocore
import boto3
import random

logLevel = os.getenv("LOG_LEVEL", "ERROR").upper()
log   = logging.getLogger()
log.setLevel(logLevel)


def lambda_handler(event, context):
    status = 200
    message = 'successful'
    log.debug(event)

    fileCount = os.getenv('FILE_COUNT', 1)
    try:
        s3BucketName = os.environ['BUCKET_NAME']
    except KeyError:
        message = 'Cannot find BUCKET_NAME environment variable'
        log.error(message)
        status = 404
    else:
        # Check bucket exists
        try:
            s3 = boto3.resource('s3')
            s3.meta.client.head_bucket(Bucket=s3BucketName)
        except botocore.exceptions.ClientError as e:
            status = e.response['Error']['Code']
            if status == '403':
                message = f"Cannot access {s3BucketName}"
            elif status == '404':
                message = f"Bucket {s3BucketName} doesn't exist."
            else:
                message = f"Unexpected error checking bucket {s3BucketName} - {e.response['Error']['Message']}"

            log.error(message)

    return{
        'statusCode': status,
        'body': json.dumps(message)
    }

    




