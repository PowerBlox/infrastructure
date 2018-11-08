variable "namespace" {}
variable "apigw_rest_api_exec_arn" {}
variable "dynamodb_table_readings_name" {}
variable "dynamodb_table_readings_arn" {}
variable "s3_bucket_arn" {}
variable "mysql_server_arn" {}
variable "mysql_server_endpoint" {}

variable "lambda_readings_pkg" {
  type    = "string"
  default = "lambda-readings.zip"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

# data.template_file.lambda_iam_policy.rendered
data "template_file" "lambda_iam_policy" {
  template = "${file("${path.module}/policies/lambda.json")}"

  vars {
    s3_bucket_arn      = "${var.s3_bucket_arn}"
    mysql_server_arn   = "${var.mysql_server_arn}"
    dynamodb_table_arn = "${var.dynamodb_table_readings_arn}"
  }
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
  depends_on       = ["aws_iam_policy_attachment._"]
  filename         = "${var.lambda_readings_pkg}"
  function_name    = "${var.namespace}-device-readings"
  handler          = "lambda.run"
  role             = "${aws_iam_role._.arn}"
  runtime          = "python3.6"
  timeout          = 30
  publish          = true
  vpc_config {
    subnet_ids         = ["${data.aws_subnet_ids.all.ids}"]
    security_group_ids = ["${data.aws_security_group.default.id}"]
  }
  environment {
    variables = {
      DYNAMODB_TABLE = "${var.dynamodb_table_readings_name}"
      MYSQL_HOST     = "${var.mysql_server_endpoint}"
    }
  }
  source_code_hash = "${base64sha256(file("${var.lambda_readings_pkg}"))}"
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

# aws_iam_policy
resource "aws_iam_policy" "_" {
  name   = "${var.namespace}-api-lambda"
  policy = "${data.template_file.lambda_iam_policy.rendered}"
}

# aws_iam_policy_attachment
resource "aws_iam_policy_attachment" "_" {
  name       = "${var.namespace}-api-lambda"
  policy_arn = "${aws_iam_policy._.arn}"
  roles      = ["${aws_iam_role._.name}"]
}
