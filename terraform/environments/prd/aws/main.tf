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


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  modules "vpcs" {
    source       = "../../terraform/modules/aws/vpc/"
    name         = local.vpcs["omega-tf"].name
    cidr         = local.vpcs["omega-tf"].cidr
    internet_gws = local.vpcs["omega-tf"].internet_gws
    nat_gws      = local.vpcs["omega-tf"].nat_gws
    subnets      = local.vpcs["omega-tf"].subnets
  }


  owners = ["099720109477"] # Canonical
}
#