locals {
omega_rds = {
  engine = "postgres"
  storage = "20"
  db_subnet_name = "subnet-db"
  publicly_accessible = false
  # subnet_db = ""
  name = "omega-db-tf"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  username = ""
  password = ""
  final_snap = "true"
  protocol = "tcp"
  port = "5432"
  cidr = ["0.0.0.0/0"]
  sg_name = "sg-rds-db"
}
}