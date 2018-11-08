
output "dynamodb_table_readings_name" {
  value = "${aws_dynamodb_table.readings.name}"
}

output "dynamodb_table_readings_arn" {
  value = "${aws_dynamodb_table.readings.arn}"
}

output "mysql_server_arn" {
  value = "${module.mysql.this_db_instance_arn}"
}

output "mysql_server_endpoint" {
  value = "${module.mysql.this_db_instance_endpoint}"
}
