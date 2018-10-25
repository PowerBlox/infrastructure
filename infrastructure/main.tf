variable aws_profile {}
variable aws_region {}
variable hosted_zone {}
variable prototype_hostname {}

provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.aws_profile}"
  version                 = "~> 1.41"
}

// prototype infrastructure with node-red running on a single ec2 ubuntu instance
module "prototype" {
  source             = "./prototype"
  hosted_zone        = "${var.hosted_zone}"
  prototype_hostname = "${var.prototype_hostname}"
}
