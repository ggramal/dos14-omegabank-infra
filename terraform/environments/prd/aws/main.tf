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
  rds_subnets = local.vpcs.omega-tf.rds_subnets
}

module "omega_rds"{
 source = "../../../modules/aws/rds/"
 vpc_id = module.vpcs.vpc_id
 db_subnet_name = local.omega_rds.db_subnet_name
 publicly_accessible = local.omega_rds.publicly_accessible
 engine_version = local.omega_rds.engine_version
 name = local.omega_rds.name
 engine = local.omega_rds.engine
 storage = local.omega_rds.storage
 instance_class = local.omega_rds.instance_class
 username = local.omega_rds.username
 password = local.omega_rds.password
 final_snap = local.omega_rds.final_snap
 sg_name = local.omega_rds.sg_name
 rds_subnet_ids = module.vpcs.rds_subnet_ids
 rds_sg = local.sg_rds
}

module "route53" {
 source       = "../../../modules/aws/route53/"
 zone_name       = local.route53.zone_name
 record_name     = local.route53.record_name
 record_type     = local.route53.record_type
 cname_records      = local.route53.cname_records
}

#  owners = ["099720109477"] # Canonical
# }
# #


# module "asg"{
#   source       = "../../../modules/aws/asg/"
#   vpc_id = module.vpcs.vpc_id
#   security_group = local.security_group
#   autoscaling_groups = local.autoscaling_groups
#   launch_template = local.launch_template
# }


module "asg"{
  source       = "../../../modules/aws/asg/"
  vpc_id = module.vpcs.vpc_id
  asg_sg = local.asgs.asg_sg
  asg_services = local.asgs.asgs_services

}