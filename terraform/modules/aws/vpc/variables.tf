locals {
  vps = {
    omega-tf = {
      name = "omega-tf"
      cidr = "10.100.0.0/16"
      internet_gws = {
        "omega_igw1_tf" = {
          name = "omega_igw1_tf"
        }
      }
    }
    nat_gws = {
      nat1 = {
        name = "omega_nat1-tf"
      }
    }
    subnets = {
      public_subnet1 = {
        name                = "omega_public1-tf"
        cidr                = "10.100.11.0/24"
        public_ip_on_launch = true
        availability_zone   = "eu-west-1a"
        routes = [
          {
            cidr        = "0.0.0.0/0"
            internet_gw = "omega_igw1_tf"
          }
        ]
      }
      private_subnet1 = {
        name              = "omega_private1-tf"
        cidr              = "10.100.21.0/24"
        availability_zone = "eu-west-1a"
        routes = [
          {
            cidr   = "0.0.0.0/0"
            nat_gw = "omega_nat1-tf"
          }
        ]
      }
    }
  }
}
