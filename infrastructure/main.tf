variable aws_profile {}
variable aws_region {}
variable hosted_zone {}
variable prototype_hostname {}

variable namespace {}
variable cognito_identity_pool_name {}
variable cognito_identity_pool_provider {}

provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.aws_profile}"
  version                 = "~> 1.41"
}

# prototype infrastructure with node-red running on a single ec2 ubuntu instance
# this has been created manually, uncomment the following to switch to a fully managed solution
/*****************************************
module "prototype" {
  source             = "./prototype"
  hosted_zone        = "${var.hosted_zone}"
  prototype_hostname = "${var.prototype_hostname}"
}
*****************************************/

# cognito
module "auth" {
  source                         = "./auth"
  region                         = "${var.aws_region}"
  namespace                      = "${var.namespace}"
  cognito_identity_pool_name     = "${var.cognito_identity_pool_name}"
  cognito_identity_pool_provider = "${var.cognito_identity_pool_provider}"
}

# db
module "db" {
  source    = "./db"
  namespace = "${var.namespace}"
}

# api gateway
module "apigw" {
  source                = "./apigw"
  region                = "${var.aws_region}"
  namespace             = "${var.namespace}"
  api_stage             = "dev"
  cognito_user_pool_arn = "${module.auth.cognito_user_pool_arn}"
  lambda_arn            = "${module.api.lambda_readings_arn}"
}

# lambda
module "api" {
  source                  = "./api"
  namespace               = "${var.namespace}"
  apigw_rest_api_exec_arn = "${module.apigw.apigw_rest_api_exec_arn}"
  dynamodb_table_readings = "${module.db.dynamodb_table_readings}"
}
