#create security group for the database

resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable postgres access on port 5432"
  vpc_id      = var.vpc_id

  ingress {
    description = "rds private subnet access"
    from_port   = var.rds_sg.ingress.from_port
    to_port     = var.rds_sg.ingress.to_port
    protocol    = var.rds_sg.ingress.protocol
    cidr_blocks = var.rds_sg.ingress.cidr_blocks
  }

  egress {
    from_port   = var.rds_sg.egress.from_port
    to_port     = var.rds_sg.egress.to_port
    protocol    = var.rds_sg.egress.protocol
    cidr_blocks = var.rds_sg.egress.cidr_blocks
  }

  tags = {
    Name = var.sg_name
  }
}


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = var.db_subnet_name
  subnet_ids = var.rds_subnet_ids


  tags = {
    Name = "rds-subnet-tf"
  }
}

# create the rds instance
resource "aws_db_instance" "omega_db" {
  engine                 = var.engine
  allocated_storage      = var.storage
  db_name                = var.name
  publicly_accessible    = var.publicly_accessible
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  skip_final_snapshot    = var.final_snap
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  identifier             = var.identifier
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
}
