variable "namespace" {}

variable "stage_env" {}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.namespace}-device-readings-${var.stage_env}-logs"
  acl    = "log-delivery-write"

  tags {
    Name        = "Logs for device readings ${var.stage_env}"
    Environment = "${var.stage_env}"
  }
}

resource "aws_s3_bucket" "storage" {
  bucket = "${var.namespace}-device-readings-${var.stage_env}"
  acl    = "private"

  logging {
    target_bucket = "${aws_s3_bucket.logging.id}"
    target_prefix = "log/"
  }

  tags {
    Name        = "Storage for device readings ${var.stage_env}"
    Environment = "${var.stage_env}"
  }
}
