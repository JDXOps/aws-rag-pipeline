output "db_url" {
  description = "The URL of the RDS Postgres Instance."
  value = aws_db_instance.default.endpoint
}
