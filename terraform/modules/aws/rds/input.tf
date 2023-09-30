variable "vpc_id" {
}

variable "rds_subnet_ids" {
}


variable "engine" {
  description = "db_engine"
  type        = string
}

variable "db_subnet_name" {
  description = "db_subnet_name"
  type        = string
}

variable "publicly_accessible" {
  description = "publicly_accessible"
  type        = bool
}

variable "name" {
  description = "db_name"
  type        = string
}

variable "storage" {
  description = "allocated_storage"
  type        = number
}

variable "engine_version" {
  description = "engine_version"
  type        = string
}

variable "instance_class" {
  description = "instance_class"
  type        = string
}

variable "password" {
  description = "password for db user"
  type        = string
  sensitive   = true
  default     = null
}

variable "username" {
  description = "username db"
  type        = string
  sensitive   = true
}

variable "final_snap" {
  description = "skip final snapshot"
  type        = bool
}

variable "identifier" {
  description = "omegabank-tf"
}

variable "sg_name" {
  description = "RDS security groups name"
  type        = string
}

variable "rds_sg" {
  description = "Secret group for rds"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
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

