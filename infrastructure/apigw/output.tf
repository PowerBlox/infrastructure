
output "apigw_rest_api_exec_arn" {
  value = "${aws_api_gateway_rest_api._.execution_arn}"
}

output "aws_api_gateway_deployment_url" {
  value = "${aws_api_gateway_deployment._.invoke_url}"
}
