
output "dynamodb_table_readings" {
  value = "${aws_dynamodb_table.readings.name}"
}
