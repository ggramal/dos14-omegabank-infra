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
#}
#
#resource "aws_instance" "jump" {
#  ami           = data.aws_ami.ubuntu.id
#  instance_type = "t2.micro"
#  subnet_id = module.vpcs.public_subnet_ids[0]
#  key_name = "test_key"
#
#
#  tags = {
#    Name = "jumphost"
#  }
#}

module "vpcs" {
  source       = "../../../modules/aws/vpc/"
  name         = local.vpcs.omega-tf.name
  cidr         = local.vpcs.omega-tf.cidr
  internet_gws = local.vpcs.omega-tf.internet_gws
  nat_gws      = local.vpcs.omega-tf.nat_gws
  subnets      = local.vpcs.omega-tf.subnets
  rds_subnets  = local.vpcs.omega-tf.rds_subnets
}

module "omega_rds" {
  source              = "../../../modules/aws/rds/"
  vpc_id              = module.vpcs.vpc_id
  db_instance         = local.rds_instances
  db_subnet_name      = local.db_subnet_name
  sg_name             = local.db_sg_name
  rds_subnet_ids      = module.vpcs.rds_subnet_ids
  rds_sg              = local.sg_rds
}

module "route53" {
  lb_zone_id    = module.alb.lb_zone_id
  lb_dns_name   = module.alb.lb_dns_name
  source        = "../../../modules/aws/route53/"
  zone_name     = local.route53.zone_name
  record_name   = local.route53.record_name
  record_type   = local.route53.record_type
  cname_records = local.route53.cname_records
  k8s_elb_dns = local.k8s_elb_dns
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
  sg_rules_egress    = local.sg_rules_egress
  alb_tgs            = local.tgs_alb
  tg_lb_type         = local.tg_lb_type
  listener_http      = local.listener_http
  listener_https     = local.listener_https
  rules              = local.rules
  extra_ssl_certs    = local.cert
}

module "eks" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-eks.git?ref=v19.16.0"
  cluster_name    = "dos14"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpcs.vpc_id
  subnet_ids               = module.vpcs.private_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    use_custom_launch_template = false
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    one = {
      min_size     = 1
      max_size     = 5
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "prd"
    Terraform   = "true"
  }
}

module "irsa-ebs-csi" {
  source  = "git@github.com:terraform-aws-modules/terraform-aws-iam//modules/iam-assumable-role-with-oidc?ref=v5.30.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}
