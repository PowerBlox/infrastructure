variable namespace {}

resource "aws_dynamodb_table" "readings" {
  name           = "${var.namespace}-device-readings"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "DeviceId"
  range_key      = "ReadingRange"

  attribute = [{
    name = "DeviceId"
    type = "S"
  }, {
    name = "ReadingRange"
    type = "S"
  }]

  tags {
    Name = "dynamodb-device-readings"
  }
}
