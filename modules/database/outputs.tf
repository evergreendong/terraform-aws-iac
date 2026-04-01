output "db_instance_id" {
  value = aws_db_instance.db.id
}

output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}