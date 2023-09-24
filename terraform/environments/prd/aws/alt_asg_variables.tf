locals {
asgs = {
  asg_sg = {
    ingress_443 = {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    }
    ingress_80 = {
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    }
    egress = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
    }
  }
  asgs_services = {
    asg_ivanoff_authn_tf = {
      lt = {
        name = "lt-authn-tf"
#        path = "./files/cloud-configs/authn.yaml"
      }
      asg = {
        name = "asg-authn-tf"
        availability_zones = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
        desired_capacity = 2
        min_size = 2
        max_size = 4
      }
    }

    asg_ivanoff_authz_tf = {
      lt = {
        name = "lt-authz-tf"
#        path = "./files/cloud-configs/authz.yaml"
      }
      asg = {
        name = "asg-authz-tf"
        availability_zones = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
        desired_capacity = 2
        min_size = 2
        max_size = 4
      }
    }

    asg_ivanoff_bank_tf = {
      lt = {
        name = "lt-bank-tf"
#        path = "./files/cloud-configs/bank.yaml"
      }
      asg = {
        name = "asg-bank-tf"
        availability_zones = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
        desired_capacity = 2
        min_size = 2
        max_size = 4
      }
    }
  }
}
}