import os
import boto3
from boto3.dynamodb.conditions import Key

from datetime import datetime, timedelta

from .app import app
from .utils.sqlalchemy import get_session, row2dict
from .models import Device


@app.route('/echo_vars')
def echo_vars():
    env_vars = ['DYNAMODB_TABLE']
    return {
        "env": {v: os.getenv(v) for v in env_vars}
    }


@app.route('/devices')
def get_devices():
    session = get_session()
    return [row2dict(row) for row in session.query(Device).all()]


@app.route('/readings/{device_id}')
def get_readings(device_id):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(os.getenv('DYNAMODB_TABLE'))

    date_end = datetime.now()
    date_start = date_end - timedelta(days=15)

    # field names as defined in /infrastructure/db/dynamo.tf
    c1 = Key('DeviceId').eq(f'device_{device_id}')
    c2 = Key('ReadingRange').between(
        str(int(date_start.timestamp())),
        str(int(date_end.timestamp())))

    response = table.query(KeyConditionExpression=c1 & c2)
    return response['Items']