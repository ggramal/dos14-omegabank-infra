terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
  backend "s3" {
    bucket         = "dos14-tf-state"
    key            = "omega/prd/aws/state.tfstate"
    dynamodb_table = "tf_state_omega"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}


#data "aws_ami" "ubuntu" {
#  most_recent = true
#
#  filter {
#    name   = "name"
#    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
#  }
#
#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
#
#}

module "vpcs" {
  source       = "../../../modules/aws/vpc/"
  name         = local.vpcs.omega-tf.name
  cidr         = local.vpcs.omega-tf.cidr
  internet_gws = local.vpcs.omega-tf.internet_gws
  nat_gws      = local.vpcs.omega-tf.nat_gws
  subnets      = local.vpcs.omega-tf.subnets
}

module "omega_rds"{
  source = "../../../modules/aws/rds/"
  vpc_id = module.vpcs.vpc_id
  engine_version = local.omega_rds.engine_version
  name = local.omega_rds.name
  engine = local.omega_rds.engine
  storage = local.omega_rds.storage
  instance_class = local.omega_rds.instance_class
  username = local.omega_rds.username
  password = local.omega_rds.password
  final_snap = local.omega_rds.final_snap
  cidr = local.omega_rds.cidr
  port = local.omega_rds.port
  protocol = local.omega_rds.protocol
  sg_name = local.omega_rds.sg_name
}


#  owners = ["099720109477"] # Canonical
#}
##