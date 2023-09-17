#create security group for the database

resource "aws_security_group" "database_security_group" {
name        = "database security group"
description = "enable postgres access on port 5432"
vpc_id      = var.vpc_id

ingress {
description      = "rds access"
from_port        = var.port
to_port          = var.port
protocol         = var.protocol
#security_groups  =
cidr_blocks = var.cidr
}

egress {
from_port        = var.port
to_port          = var.port
protocol         = var.protocol
cidr_blocks      = var.cidr
}

tags   = {
Name = var.sg_name
}
}


 # create the subnet group for the rds instance
 resource "aws_db_subnet_group" "database_subnet_group" {
 name         = var.db_subnet_name
 subnet_ids   = var.rds_subnet_ids


 tags = {
 Name = "rds-subnet-tf"
 }
 }
# resource "aws_default_subnet" "default_subnet_rds" {
# #   vpc_id = var.vpc_id
# #   cidr_block        = "10.100.60.0/24"
#   availability_zone = "us-east-1b"
# }

# create the rds instance
resource "aws_db_instance" "omega_db" {
engine               = var.engine
allocated_storage    = var.storage
db_name              = var.name
publicly_accessible = var.publicly_accessible
engine_version       = var.engine_version
instance_class       = var.instance_class
username             = var.username
password             = var.password
#parameter_group_name = "default.mysql5.7"
skip_final_snapshot  = var.final_snap
db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
}
