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

module "route53" {
  source       = "../../../modules/aws/route53/"
  zone_name       = local.route53.zone_name
  record_name     = local.route53.record_name
  record_type     = local.route53.record_type
  cname_record_name = local.route53.cname_record_name
  cname_record_type = local.route53.cname_record_type
  cname_record_ttl  = local.route53.cname_record_ttl
  cname_record_value = local.route53.cname_record_value
}


#  owners = ["099720109477"] # Canonical
#}
##