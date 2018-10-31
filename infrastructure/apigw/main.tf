variable region {}
variable namespace {}
variable api_stage {}
variable cognito_user_pool_arn {}
variable lambda_arn {}

# the name of the game
resource "aws_api_gateway_rest_api" "_" {
  name        = "${var.namespace}-device-api"
  description = "Proxy API with Cognito Authentication"
}

# add cors
module "cors" {
  source          = "github.com/squidfunk/terraform-aws-api-gateway-enable-cors"
  version         = "0.1.0"
  api_id          = "${aws_api_gateway_rest_api._.id}"
  api_resource_id = "${aws_api_gateway_resource.proxy.id}"
}

# cognito authorizer for the api
resource "aws_api_gateway_authorizer" "_" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = "${aws_api_gateway_rest_api._.id}"
  provider_arns = ["${var.cognito_user_pool_arn}"]
}

# deployment
resource "aws_api_gateway_deployment" "_" {
  depends_on        = ["aws_api_gateway_integration.integration"]
  rest_api_id       = "${aws_api_gateway_rest_api._.id}"
  stage_name        = "${var.api_stage}"
  stage_description = "${md5(file("main.tf"))}"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api._.id}"
  parent_id   = "${aws_api_gateway_rest_api._.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "any" {
  rest_api_id   = "${aws_api_gateway_rest_api._.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer._.id}"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api._.id}"
  resource_id             = "${aws_api_gateway_resource.proxy.id}"
  http_method             = "${aws_api_gateway_method.any.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}
