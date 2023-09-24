locals {
security_group = {
  bank_sg = {
    name        = "bank_sg_tf"
    description = "security group"
    ingress = [
      {
        description = "Allow jumphost"
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow RDS"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
      },
	    {
        description = "Allow ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  authz_sg = {
    name        = "authz_sg_tf"
    description = "security group"
    ingress = [
      {
        description = "Allow jumphost"
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow RDS"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
      },
	    {
        description = "Allow ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  authn_sg = {
    name        = "authn_sg_tf"
    description = "security group"
    ingress = [
      {
        description = "Allow jumphost"
        from_port   = 0
        to_port     = 0
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow RDS"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.100.50.0/24", "10.100.60.0/24"]
      },
	    {
        description = "Allow ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }  
}

autoscaling_groups = {
  "bansk_asg" = {
    name                      = "banks-asg-tf"
    launch_template_id       = ""
    max_size                  = 2
    min_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
    desired_capacity          = 1
    force_delete              = true
    availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
  },
  "authz_ags" = {
    name                      = "authz-asg-tf"
    launch_template_id       = ""
    max_size                  = 3
    min_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
    desired_capacity          = 2
    force_delete              = true
    availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
  }
    "authn_asg" = {
    name                      = "authn-asg-tf"
    launch_template_id       = ""
    max_size                  = 3
    min_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
    desired_capacity          = 2
    force_delete              = true
    availability_zones                = ["eu-west-1b", "eu-west-1c", "eu-west-1a"]
  }
}

    launch_template = {
        authz_template = {
          name          = "authz-template"
          image_id      = "ami-01dd271720c1ba44f"
          instance_type = "t2.micro"
          key = "test_key"
          user_data = <<-EOT
#cloud-config
package_update: true
package_upgrade: true
packages:
  - python3-pip
  - git
write_files:
  - content: |
      127.0.0.1 ansible_connection=local
    path: /tmp/inventory.ini
    permissions: '0444'
runcmd:
  - pip install ansible
  - cd /tmp/ && git clone --branch feature-hw-26 https://github.com/avmikholap/dos14-Miholap_Aleksey_git-flow.git authz
  - cd /tmp/authz/ansible && ansible-playbook -i /tmp/inventory.ini app_playbook.yml -e branch=feature-hw-26
EOT
        }
        authn_template = {
          name                = "authn-template"
          image_id = "ami-01dd271720c1ba44f"
          instance_type = "t2.micro"
          key = "test_key"
          user_data = <<-EOT
#cloud-config
package_update: true
package_upgrade: true
packages:
 - python3-pip
 - git
write_files:
- content: |
    127.0.0.1 ansible_connection=local
  path: /tmp/inventory.ini
  permissions: '0444'
runcmd:
   - pip install ansible
   - cd /tmp/ && git clone --branch features-hw-24-26 https://github.com/CyberCuCuber/dos14-polikarpov_ruslan-gitflow.git authn
   - cd /tmp/authn/ansible && ansible-playbook -i /tmp/inventory.ini playbook.yaml
EOT
        }
        bank_template = {
          name                = "bank-template"
          image_id = "ami-01dd271720c1ba44f"
          instance_type = "t2.micro"
          key = "test_key"
          user_data = <<-EOT
#cloud-config
package_update: true
package_upgrade: true
packages:
 - python3-pip
 - git
write_files:
- content: |
    127.0.0.1 ansible_connection=local
  path: /tmp/inventory.ini
  permissions: '0444'
- content: |
    bank
  path: /tmp/.vault_pass
  permissions: '0444'
runcmd:
   - pip install ansible
   - cd /tmp/ && git clone --branch feature29 https://github.com/lowkent2me/dos14-Kot-git-flow.git bank
   - cd /tmp/bank/Ansible && ansible-playbook -i /tmp/inventory.ini playdocker.yml --vault-password-file=/tmp/.vault_pass --extra-vars "BRANCH=feature29"
EOT
            }
          
        }
}