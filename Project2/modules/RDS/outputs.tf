output "primary_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "replica_endpoint" {
  value = aws_db_instance.mysql_replica.endpoint
}