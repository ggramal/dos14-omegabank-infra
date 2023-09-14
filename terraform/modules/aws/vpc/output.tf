output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.main : subnet.id]
}