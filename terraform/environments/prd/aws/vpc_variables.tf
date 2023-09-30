locals {
  vpcs = {
    omega-tf = {
      name = "omega-tf"
      cidr = "10.100.0.0/16"
      internet_gws = {
        "omega_igw1_tf" = {
          name = "omega_igw1_tf"
        }
      }
      nat_gws = {
        "omega_nat1-tf" = {
          name   = "omega_nat1-tf"
          subnet = "public_subnet3"
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
        public_subnet2 = {
          name                = "omega_public1-tf"
          cidr                = "10.100.12.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-west-1b"
          routes = [
            {
              cidr        = "0.0.0.0/0"
              internet_gw = "omega_igw1_tf"
            }
          ]
        }
        public_subnet3 = {
          name                = "omega_public1-tf"
          cidr                = "10.100.13.0/24"
          public_ip_on_launch = true
          availability_zone   = "eu-west-1c"
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
        private_subnet2 = {
          name              = "omega_private2-tf"
          cidr              = "10.100.22.0/24"
          availability_zone = "eu-west-1b"
          routes = [
            {
              cidr   = "0.0.0.0/0"
              nat_gw = "omega_nat1-tf"
            }
          ]
        }
        private_subnet3 = {
          name              = "omega_private3-tf"
          cidr              = "10.100.23.0/24"
          availability_zone = "eu-west-1c"
          routes = [
            {
              cidr   = "0.0.0.0/0"
              nat_gw = "omega_nat1-tf"
            }
          ]
        }

      }
      rds_subnets = {
        rds_subnet_1 = {
          name              = "omega_rds_1-tf"
          cidr              = "10.100.50.0/24"
          availability_zone = "eu-west-1b"
          routes = [
            {
              cidr = "0.0.0.0/0"
            }
          ]
        }
        rds_subnet_2 = {
          name              = "omega_rds_2-tf"
          cidr              = "10.100.60.0/24"
          availability_zone = "eu-west-1a"
          routes = [
            {
              cidr = "0.0.0.0/0"
            }
          ]
        }
      }
    }

  }
          subnet_rds = {
          name              = "omega-rds-subnet-tf"
          cidr              = "10.100.50.0/24"
          availability_zone = "eu-west-1b"
} 
}

