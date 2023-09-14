output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.main : subnet.id]
}

output "rds_id" {
  value = aws_subnet.main["rds_subnet"].id
}