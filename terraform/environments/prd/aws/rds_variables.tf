locals {
  omega_rds = {
    engine              = "postgres"
    storage             = "20"
    db_subnet_name      = "subnet-db"
    publicly_accessible = false
    name                = "omegadbtf"
    engine_version      = "15.3"
    instance_class      = "db.t3.micro"
    username            = "test"
    password            = "test"
    final_snap          = "true"
    sg_name             = "sg-rds-db"
  }
  sg_rds = {
    ingress = {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
    }
  }
}