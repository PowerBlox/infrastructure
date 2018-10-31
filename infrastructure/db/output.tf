
output "dynamodb_table_readings_name" {
  value = "${aws_dynamodb_table.readings.name}"
}

output "dynamodb_table_readings_arn" {
  value = "${aws_dynamodb_table.readings.arn}"
}
