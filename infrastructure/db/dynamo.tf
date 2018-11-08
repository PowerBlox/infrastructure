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

/******************************************************
 * endpoint has been manually configured in aws to allow access to dynamo db from lambda,
 * this ideally should be done in code but leaving it now for lack of resources
 * not entirely sure how to configure the route, check this out https://gist.github.com/radeksimko/929a41675323eefed023

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"


  route {
    cidr_block = "YOUR-IP/32"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
}

resource "aws_vpc_endpoint" "private-dynamodb" {
  vpc_id = "${data.aws_vpc.default.id}"
  # aws ec2 describe-vpc-endpoint-services --region eu-west-1 --profile power-blox
  service_name = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = ["${aws_route_table.default.id}"]
  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY
}
*/
