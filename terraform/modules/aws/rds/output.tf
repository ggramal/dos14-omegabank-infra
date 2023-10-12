output "rds_security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.database_security_group.id, null)
}