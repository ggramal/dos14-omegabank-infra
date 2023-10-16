locals {
  asgs = {
    asg_sg = {
      ingress_alb = {
        from_port   = 0
        to_port     = 0
        protocol    = "all"
        sg_id = module.alb.alb_security_group_id
      }
      ingress_postgres = {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        sg_id = module.omega_rds.rds_security_group_id
      }
      ingress_jump = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24"]
      }
      egress = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
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
          desired_capacity = 0
          min_size         = 0
          max_size         = 4
          tg_alb           = module.alb.tg_authn_arn
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
          desired_capacity = 0
          min_size         = 0
          max_size         = 4
          tg_alb           = module.alb.tg_authz_arn
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
          desired_capacity = 0
          min_size         = 0
          max_size         = 4
          tg_alb           = module.alb.tg_bank_arn
        }
      }
    }
  }
}

