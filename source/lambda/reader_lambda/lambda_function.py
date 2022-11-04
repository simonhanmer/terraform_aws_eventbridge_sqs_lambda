import os
import json
import logging
import botocore
import boto3


logLevel = os.getenv("LOG_LEVEL", "ERROR").upper()
log   = logging.getLogger()
log.setLevel(logLevel)


def lambda_handler(event, context):
    log.debug(event)
    messages = event['Records']
    log.info(f"Found {len(messages)} messages")

    for message in messages:
        log.debug(f"message body = {json.loads(message['body'])}")
        requestParameters=json.loads(message['body'])['detail']['requestParameters']
        log.info(f"Process {requestParameters['key']} uploaded to bucket {requestParameters['bucketName']}")

    raise Exception('force failure of lambda')
        