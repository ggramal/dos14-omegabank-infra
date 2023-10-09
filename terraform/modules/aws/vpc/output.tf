output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.main : subnet.id]
}

output "private_subnet_ids" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.main :
    subnet_obj.id
    if length(regexall("private", subnet_key)) > 0
  ]
}

output "public_subnet_ids" {
  value = [
    for subnet_key, subnet_obj in aws_subnet.main :
    subnet_obj.id
    if length(regexall("public", subnet_key)) > 0
  ]
}

output "rds_subnet_ids" {
  value = [for rds_subnet in aws_subnet.main : rds_subnet.id]
}


#output "rds_subnet_az" {
#  value = aws_subnet.main["rds_subnet"].availability_zone
#}