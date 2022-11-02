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
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

