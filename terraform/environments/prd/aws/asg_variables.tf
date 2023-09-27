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
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
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
          name = "lt-authn-tf"
          path = "./files_config/authn.yaml"
          instance_type = "t2.micro"
          key_name = "test_key"

        }
        asg = {
          name = "asg-authn-tf"
          availability_zones = ["eu-west-1c", "eu-west-1a"]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }

      asg_omega_authz_tf = {
        lt = {
          name = "lt-authz-tf"
          path = "./files_config/authz.yaml"
          instance_type = "t2.micro"
          key_name = "test_key"

        }
        asg = {
          name = "asg-authz-tf"
          availability_zones = ["eu-west-1c", "eu-west-1a"]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }

      asg_omega_bank_tf = {
        lt = {
          name = "lt-bank-tf"
          path = "./files_config/bank.yaml"
          instance_type = "t2.micro"
          key_name = "test_key"
        }
        asg = {
          name = "asg-bank-tf"
          availability_zones = ["eu-west-1b", "eu-west-1a"]
          desired_capacity = 2
          min_size = 2
          max_size = 4
        }
      }
    }  
  }
}









# locals {
# security_group = {
#   bank = {
#     name        = "bank_sg_tf"
#     description = "security group"
#     ingress = [
#       {
#         description = "Allow jumphost"
#         from_port   = 0
#         to_port     = 0
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "Allow RDS"
#         from_port   = 5432
#         to_port     = 5432
#         protocol    = "tcp"
#         cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
#       },
# 	    {
#         description = "Allow ALB"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
#   authz = {
#     name        = "authz_sg_tf"
#     description = "security group"
#     ingress = [
#       {
#         description = "Allow jumphost"
#         from_port   = 0
#         to_port     = 0
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "Allow RDS"
#         from_port   = 5432
#         to_port     = 5432
#         protocol    = "tcp"
#         cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
#       },
# 	    {
#         description = "Allow ALB"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
#   authn = {
#     name        = "authn_sg_tf"
#     description = "security group"
#     ingress = [
#       {
#         description = "Allow jumphost"
#         from_port   = 0
#         to_port     = 0
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "Allow RDS"
#         from_port   = 5432
#         to_port     = 5432
#         protocol    = "tcp"
#         cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
#       },
# 	    {
#         description = "Allow ALB"
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }  
# }

# autoscaling_groups = {
#   bank = {
#     name                      = "banks-asg-tf"
#     launch_template_id       = ""
#     max_size                  = 2
#     min_size                  = 1
#     health_check_grace_period = 300
#     health_check_type         = "EC2"
#     desired_capacity          = 1
#     force_delete              = true
#     availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
#   },
#   authz = {
#     name                      = "authz-asg-tf"
#     launch_template_id       = ""
#     max_size                  = 3
#     min_size                  = 1
#     health_check_grace_period = 300
#     health_check_type         = "EC2"
#     desired_capacity          = 2
#     force_delete              = true
#     availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
#   }
#   authn = {
#     name                      = "authn-asg-tf"
#     launch_template_id       = ""
#     max_size                  = 3
#     min_size                  = 1
#     health_check_grace_period = 300
#     health_check_type         = "EC2"
#     desired_capacity          = 2
#     force_delete              = true
#     availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
#   }
# }

#     launch_template = {
#         authz = {
#           name          = "authz-template-tf"
#           image_id      = "ami-01dd271720c1ba44f"
#           instance_type = "t2.micro"
#           key = "test_key"
#           path = "./files_config/authz.yaml" 

#         }
#         authn = {
#           name                = "authn-template-tf"
#           image_id = "ami-01dd271720c1ba44f"
#           instance_type = "t2.micro"
#           key = "test_key"
#           path = "./files_config/authn.yaml" 


#         }
#         bank = {
#           name                = "bank-template-tf"
#           image_id = "ami-01dd271720c1ba44f"
#           instance_type = "t2.micro"
#           key = "test_key"
#           path = "./files_config/bank.yaml" 
#             }
          
#         }
# }