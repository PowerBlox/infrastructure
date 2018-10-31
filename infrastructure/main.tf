variable aws_profile {}
variable aws_region {}
variable hosted_zone {}
variable prototype_hostname {}

variable namespace {}
variable cognito_identity_pool_name {}
variable cognito_identity_pool_provider {}

variable stage_env {
  type    = "string"
  default = "dev"
}

provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.aws_profile}"
  version                 = "~> 1.41"
}

# used to fetch ssl certificates for global endpoints (must be defined in us east 1)
provider "aws" {
  alias                   = "useast1"
  region                  = "us-east-1"
}

# prototype infrastructure with node-red running on a single ec2 ubuntu instance
module "prototype" {
  source             = "./prototype"
  hosted_zone        = "${var.hosted_zone}"
  prototype_hostname = "${var.prototype_hostname}"
}

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
  stage_env = "${var.stage_env}"
}

# api gateway
module "storage" {
  source    = "./storage"
  namespace = "${var.namespace}"
  stage_env = "${var.stage_env}"
}

# api gateway
module "apigw" {
  source                = "./apigw"
  region                = "${var.aws_region}"
  namespace             = "${var.namespace}"
  api_stage             = "${var.stage_env}"
  hosted_zone           = "${var.hosted_zone}"
  cognito_user_pool_arn = "${module.auth.cognito_user_pool_arn}"
  lambda_arn            = "${module.api.lambda_readings_arn}"
}

# lambda
module "api" {
  source                       = "./api"
  namespace                    = "${var.namespace}"
  apigw_rest_api_exec_arn      = "${module.apigw.apigw_rest_api_exec_arn}"
  dynamodb_table_readings_name = "${module.db.dynamodb_table_readings_name}"
  dynamodb_table_readings_arn  = "${module.db.dynamodb_table_readings_arn}"
  s3_bucket_arn                = "${module.storage.s3_bucket_arn}"
  mysql_server_arn             = "${module.db.mysql.this_db_instance_arn}"
}

data "template_file" "frontend_exports" {
  template = "${file("${path.cwd}/templates/frontend_exports.json")}"

  vars {
    region              = "${var.aws_region}"
    userPoolId          = "${module.auth.cognito_user_pool_id}"
    userPoolWebClientId = "${module.auth.cognito_user_pool_client_id}"
    apigw_endpoint      = "${module.apigw.aws_api_gateway_deployment_url}"
  }
}

resource "local_file" "frontend_exports" {
  filename = "${path.cwd}/../frontend/readings/public/src/aws-resources.${var.stage_env}.js"
  content  = "${data.template_file.frontend_exports.rendered}"
}
