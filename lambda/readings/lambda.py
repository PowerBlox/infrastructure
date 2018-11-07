from dotenv import load_dotenv

from readings.app import app

load_dotenv()



def run(event, context):
    """main lambda handler, should route requests to specific functions depending on path

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
    return app.handle(event)


if __name__ == '__main__':
    run(None, None)
