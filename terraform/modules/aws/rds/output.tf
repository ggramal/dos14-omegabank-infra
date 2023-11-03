output "rds_security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.database_security_group.id, null)
}

output "endpoint" {
  value = aws_db_instance.omega_db.endpoint
}

output "db_name" {
  value = aws_db_instance.omega_db.db_name
}
