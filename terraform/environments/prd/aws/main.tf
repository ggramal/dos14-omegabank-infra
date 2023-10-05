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

module "vpcs" {
  source       = "../../../modules/aws/vpc/"
  name         = local.vpcs.omega-tf.name
  cidr         = local.vpcs.omega-tf.cidr
  internet_gws = local.vpcs.omega-tf.internet_gws
  nat_gws      = local.vpcs.omega-tf.nat_gws
  subnets      = local.vpcs.omega-tf.subnets
  rds_subnets  = local.vpcs.omega-tf.rds_subnets
}

#module "omega_rds" {
#  source              = "../../../modules/aws/rds/"
#  vpc_id              = module.vpcs.vpc_id
#  db_subnet_name      = local.omega_rds.db_subnet_name
#  publicly_accessible = local.omega_rds.publicly_accessible
#  engine_version      = local.omega_rds.engine_version
#  name                = local.omega_rds.name
#  engine              = local.omega_rds.engine
#  storage             = local.omega_rds.storage
#  instance_class      = local.omega_rds.instance_class
#  username            = local.omega_rds.username
#  password            = random_password.password.result
#  final_snap          = local.omega_rds.final_snap
#  sg_name             = local.omega_rds.sg_name
#  rds_subnet_ids      = module.vpcs.rds_subnet_ids
#  rds_sg              = local.sg_rds
#  identifier          = local.omega_rds.identifier
#}

module "route53" {
  lb_zone_id    = module.alb.lb_zone_id
  lb_dns_name   = module.alb.lb_dns_name
  source        = "../../../modules/aws/route53/"
  zone_name     = local.route53.zone_name
  record_name   = local.route53.record_name
  record_type   = local.route53.record_type
  cname_records = local.route53.cname_records
}

module "asg" {
  source             = "../../../modules/aws/asg/"
  vpc_id             = module.vpcs.vpc_id
  private_subnet_ids = module.vpcs.private_subnet_ids
  asg_sg             = local.asgs.asg_sg
  asg_services       = local.asgs.asgs_services
}

module "alb" {
  vpc_id             = module.vpcs.vpc_id
  public_subnet_ids  = module.vpcs.public_subnet_ids
  source             = "../../../modules/aws/alb/"
  name               = local.name
  internal           = local.internal
  load_balancer_type = local.load_balancer_type
  ip_address_type    = local.ip_address_type
  sg_name            = local.sg_name
  sg_description     = local.sg_description
  sg_rules_ingress   = local.sg_rules_ingress
  alb_tgs            = local.tgs_alb
  tg_lb_type         = local.tg_lb_type
  listener_http      = local.listener_http
  listener_https     = local.listener_https
  rules              = local.rules
  extra_ssl_certs    = local.cert
}