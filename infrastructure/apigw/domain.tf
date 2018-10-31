variable "hosted_zone" {}

# this certificate must be defined in the us-east-1 region for an edge optimised gateway
# https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains-prerequisites.html
#
# mh, currently broken, I've added a comment here: https://github.com/hashicorp/terraform/issues/10957#issuecomment-434752071
/***************************************************************************************
data "aws_acm_certificate" "api" {
  provider = "aws.useast1"
  domain   = "api.power-blox.cloud"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "_" {
  name = "${var.hosted_zone}"
}

resource "aws_api_gateway_domain_name" "_" {
  domain_name      = "api.power-blox.cloud"
  certificate_arn  = "${data.aws_acm_certificate.api.arn}"
}

resource "aws_api_gateway_base_path_mapping" "_" {
  api_id      = "${aws_api_gateway_rest_api._.id}"
  stage_name  = "${aws_api_gateway_deployment._.stage_name}"
  domain_name = "${aws_api_gateway_domain_name._.domain_name}"
}

resource "aws_route53_record" "_" {
  zone_id = "${data.aws_route53_zone._.id}" # See aws_route53_zone for how to create this
  name    = "${aws_api_gateway_domain_name._.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name._.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name._.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}
***************************************************************************************/
