import os
import json
import random
from datetime import datetime, timedelta
import boto3

os.environ['AWS_PROFILE'] = 'power-blox'
DEF_DEVICE_ID = 1
DEF_READ_GAP_MIN = 15


def run():
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.getenv('DYNAMODB_TABLE'))
    now = datetime.now()
    with table.batch_writer() as batch:
        for i in range(10):
            when = now - timedelta(minutes=(i * DEF_READ_GAP_MIN))
            value = {
                'Voltage': random.randint(12, 14),
                'Temperature': random.randint(18, 28)
            }
            batch.put_item(
                Item={
                    'DeviceId': f'device_{DEF_DEVICE_ID}',
                    'ReadingRange': str(int(when.timestamp())),
                    'ReadingValue': json.dumps(value),
                }
            )

if __name__ == '__main__':
    run()
