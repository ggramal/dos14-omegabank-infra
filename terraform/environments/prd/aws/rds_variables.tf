locals {
omega_rds = {
  engine = "postgres"
  storage = "20"
  name = "omega-db-tf"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  username = "postgres"
  password = "12345"
  final_snap = "true"
  protocol = "tcp"
  port = "5432"
  cidr = ["0.0.0.0/0"]
  sg_name = "sg-rds-db"
}
}