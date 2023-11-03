locals {
  rds_instances = {
    omegabank = {
      engine              = "postgres"
      storage             = "20"
      db_subnet_name      = "subnet-db"
      publicly_accessible = false
      name                = "omegabank"
      engine_version      = "15.3"
      instance_class      = "db.t3.micro"
      username            = "omega"
      password            = random_password.password.result
      identifier          = "omegabank-rds-tf"
      final_snap          = "true"
      sg_name             = "sg-rds-db"
    }
    ivanoff = {
      engine              = "postgres"
      storage             = "20"
      db_subnet_name      = "subnet-db"
      publicly_accessible = false
      name                = "ivanoffbank"
      engine_version      = "15.3"
      instance_class      = "db.t3.micro"
      username            = "ivanoff"
      password            = random_password.password.result
      identifier          = "ivanoff-rds-tf"
      final_snap          = "true"
      sg_name             = "sg-rds-db"
    }
  }
  sg_rds = {
    ingress = {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  db_subnet_name = "subnet-db"
  db_sg_name = "sg-rds-db"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}

output "password_omega" {
  value     = local.rds_instances.omegabank.password
  sensitive = true
}

output "username_omega" {
  value = local.rds_instances.omegabank.username
  sensitive = true
}

output "password_ivanoff" {
  value     = local.rds_instances.ivanoff.password
  sensitive = true
}

output "username_ivanoff" {
  value = local.rds_instances.ivanoff.username
  sensitive = true
}