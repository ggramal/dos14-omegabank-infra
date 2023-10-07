locals {
  asgs = {
    asg_sg = {
      ingress_443 = {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
      }
      ingress_80 = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
      }
      egress = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24"]
      }
    }
    asgs_services = {
      asg_omega_authn_tf = {
        lt = {
          name          = "lt-authn-tf"
          path          = "./files_config/authn.yaml"
          instance_type = "t2.micro"
          key_name      = "test_key"
          git_branch    = "features-hw-24-26"
          secrets       = var.secrets.authn

        }
        asg = {
          name             = "asg-authn-tf"
          desired_capacity = 2
          min_size         = 2
          max_size         = 4
        }
      }

      asg_omega_authz_tf = {
        lt = {
          name          = "lt-authz-tf"
          path          = "./files_config/authz.yaml"
          instance_type = "t2.micro"
          key_name      = "test_key"
          git_branch    = "feature-hw-26"
          secrets       = var.secrets.authz

        }
        asg = {
          name             = "asg-authz-tf"
          desired_capacity = 2
          min_size         = 2
          max_size         = 4

        }
      }

      asg_omega_bank_tf = {
        lt = {
          name          = "lt-bank-tf"
          path          = "./files_config/bank.yaml"
          instance_type = "t2.micro"
          key_name      = "test_key"
          git_branch    = "feature29"
          secrets       = var.secrets.bank
        }
        asg = {
          name             = "asg-bank-tf"
          desired_capacity = 2
          min_size         = 2
          max_size         = 4
        }
      }
    }
  }
}

