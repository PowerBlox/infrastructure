# this certificate must be defined in the us-east-1 region for an edge optimised gateway
# https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains-prerequisites.html
data "aws_acm_certificate" "api" {
  domain   = "api.power-blox.cloud"
  statuses = ["ISSUED"]
}

# resource "aws_api_gateway_domain_name" "_" {
#   domain_name      = "api.power-blox.cloud"
#   certificate_arn  = "${data.aws_acm_certificate.api.arn}"
# }

# TODO: assign to api gw
# https://www.terraform.io/docs/providers/aws/r/api_gateway_domain_name.html
# https://www.terraform.io/docs/providers/aws/r/api_gateway_base_path_mapping.html
