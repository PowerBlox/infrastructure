variable namespace {}
variable apigw_rest_api_exec_arn {}
variable dynamodb_table_readings {}

variable lambda_readings_pkg {
  type    = "string"
  default = "lambda-readings.zip"
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.readings.arn}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${var.apigw_rest_api_exec_arn}/*/*/*"
}

resource "aws_lambda_function" "readings" {
  filename         = "${var.lambda_readings_pkg}"
  function_name    = "${var.namespace}-device-readings"
  role             = "${aws_iam_role._.arn}"
  handler          = "lambda.run"
  runtime          = "python3.6"
  source_code_hash = "${base64sha256(file("${var.lambda_readings_pkg}"))}"
  timeout          = 30

  environment {
    variables = {
      DYNAMODB_TABLE = "${var.dynamodb_table_readings}"
    }
  }
}

# IAM
resource "aws_iam_role" "_" {
  name = "${var.namespace}-tf-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
