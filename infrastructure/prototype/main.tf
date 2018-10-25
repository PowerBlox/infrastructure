variable hosted_zone {}
variable prototype_hostname {}

data "aws_route53_zone" "cloud" {
  name = "${var.hosted_zone}"
}

// security group is defined in aws console to allow ssh and 1880 (node-red)
data "aws_security_group" "prototype" {
  name = "sg_prototype"
}

// iam role is defined in aws console to grant access to rds and dynamodb
data "aws_iam_role" "prototype" {
  name = "prototype"
}

/**************************************************************************
 * create resources
 */

// create instance profile
resource "aws_iam_instance_profile" "prototype" {
  name = "prototype_profile"
  role = "${data.aws_iam_role.prototype.name}"
}

// create instance
resource "aws_instance" "prototype01" {
  ami                    = "ami-0192f8607f1b79f80"
  instance_type          = "t2.micro"
  key_name               = "prototype"
  vpc_security_group_ids = ["${data.aws_security_group.prototype.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.prototype.name}"
  tags {
    Name = "node-red prototype01"
  }
}

// create elastic ip and assign instance
resource "aws_eip" "prototype01" {
  instance = "${aws_instance.prototype01.id}"
}

// create A record in hosted zone and assign elastic ip
resource "aws_route53_record" "prototype01" {
  zone_id = "${data.aws_route53_zone.cloud.zone_id}"
  name    = "${var.prototype_hostname}.${data.aws_route53_zone.cloud.name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.prototype01.public_ip}"]
}
