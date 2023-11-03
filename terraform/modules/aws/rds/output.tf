output "rds_security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.database_security_group.id, null)
}

output "endpoint_omegabank" {
  value = aws_db_instance.omega_db["omegabank"].endpoint
}

output "db_name_omegabank" {
  value = aws_db_instance.omega_db["omegabank"].db_name
}

output "endpoint_ivanoff" {
  value = aws_db_instance.omega_db["ivanoff"].endpoint
}

output "db_name_ivanoff" {
  value = aws_db_instance.omega_db["ivanoff"].db_name
}