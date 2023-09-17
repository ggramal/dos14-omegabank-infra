variable "vpc_id" {
}

 variable "rds_subnet_ids" {
 }

#variable "subnet_ids" {
#}

#variable "rds_subnet_az" {
#}

variable "engine" {
  description = "db_engine"
  type = string
}

variable "db_subnet_name" {
  description = "db_subnet_name"
  type = string
}

variable "publicly_accessible" {
  description = "publicly_accessible"
  type = bool
}

variable "name" {
  description = "db_name"
  type = string
}

# variable "subnet_db" {
#   description = "subnet_db"
#   type = number
# }

variable "storage" {
  description = "allocated_storage"
  type = number
}

variable "engine_version" {
  description = "engine_version"
  type = string
}

variable "instance_class" {
  description = "instance_class"
  type = string
}

variable "username" {
  description = "username db"
  type = string
}

variable "password" {
  description = "password db"
  type = string
}

variable "final_snap" {
  description = "skip final snapshot"
  type = bool
}

variable "port" {
  description = "Postgres port"
  type = number
}

variable "protocol" {
  description = "tcp protocol"
  type = string
}

variable "cidr" {
  description = "Vpc cidr"
  type        = list(string)
}

variable "sg_name" {
  description = "RDS security groups name"
  type = string
}

#variable "db_instance" {
#  description = "Variables map for creation RDS instance"
#  type = map(
#    object(
#      {
#        engine = string
#        name = string
#        storage = number
#        engine_version = string
#        instance_class = string
#        username = string
#        password = string
#        final_snap = string
#      }
#    )
#  )
#}