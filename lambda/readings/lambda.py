import os
import json

def run(event, context):
    """main lambda handler, should route requests to specific functions depending on path
    the implementation is beyond the scope of this demo, but in case it's needed, this
    seems to be a good starting point: https://github.com/trustpilot/python-lambdarest

    for details of contents received in the event dictionary when integrated with api gw
    check https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html

    for details of the context object, check https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html

    content-type of response is automatically set to application/json when lambda is called
    via an api gw proxy

    :param event: the result of an api gw integration with this lambda
    :type event: dictionary
    :param context: runtime information, check docs for content
    :type context: aws lambdacontext object
    :return: a processed response
    :rtype: httpresponse
    """

    env_vars = ['DYNAMODB_TABLE']
    body = {
        "event": event,
        "env": {v: os.getenv(v) for v in env_vars}
    }
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Credentials": True,
        },
        "body": json.dumps(body)
    }

if __name__ == '__main__':
    run()
