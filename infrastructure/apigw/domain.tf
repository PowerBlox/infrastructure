data "aws_acm_certificate" "api" {
  domain   = "api.power-blox.cloud"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "_" {
  domain_name      = "api.power-blox.cloud"
  certificate_name = "api gateway"
  certificate_arn  = "${data.aws_acm_certificate.arn}"
}

# TODO: assign to api gw
# https://www.terraform.io/docs/providers/aws/r/api_gateway_domain_name.html
# https://www.terraform.io/docs/providers/aws/r/api_gateway_base_path_mapping.html
