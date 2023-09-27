data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }

    owners = ["099720109477"] #Canonical
}

resource "aws_launch_template" "lt" {
    for_each = var.asg_services
    name = each.value.lt.name
    image_id = data.aws_ami.ubuntu.id
    instance_type = each.value.lt.instance_type
    key_name = each.value.lt.key_name
    vpc_security_group_ids = ["${aws_security_group.asg_sg.id}"]
    user_data = base64encode(each.value.lt.path )
}

resource "aws_autoscaling_group" "asg" {
    for_each = var.asg_services
    name = each.value.asg.name
    availability_zones = each.value.asg.availability_zones
    desired_capacity = each.value.asg.desired_capacity
    min_size = each.value.asg.min_size
    max_size = each.value.asg.max_size
    launch_template {
      id = aws_launch_template.lt[each.key].id
      version = "$Latest"
    }
}

resource "aws_security_group" "asg_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.asg_sg.ingress_443.from_port
    to_port     = var.asg_sg.ingress_443.to_port
    protocol    = var.asg_sg.ingress_443.protocol
    cidr_blocks = var.asg_sg.ingress_443.cidr_blocks
  }

  ingress {
    from_port   = var.asg_sg.ingress_80.from_port
    to_port     = var.asg_sg.ingress_80.to_port
    protocol    = var.asg_sg.ingress_80.protocol
    cidr_blocks = var.asg_sg.ingress_80.cidr_blocks
  }

  tags = {
    Name = "asg-sg-omega-tf"
  }
}


# resource "aws_security_group" "asg_security_group" {
#   for_each = var.security_group
#   name        = each.value.name
#   description = each.value.description
#   vpc_id      = var.vpc_id

#   dynamic "ingress" {
# #    for_each = var.security_group
#     for_each = [
#     for ingress in each.value.ingress:
#     ingress
#     ]
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol
#       cidr_blocks = ingress.value.cidr_blocks
#     }

#   }
# }

# resource "aws_launch_template" "omega-lt" {
#   for_each               = var.launch_template
#   name                   = each.value.name
#   image_id               = each.value.image_id
#   instance_type          = each.value.instance_type
#   key_name               = each.value.key
#   vpc_security_group_ids = [aws_security_group.asg_security_group[each.key].id]
#   # vpc_security_group_ids = ["sg-0cc962110b7f60649"]
#   # user_data              = each.value.path
#   user_data = base64encode(each.value.path)
#   depends_on = [aws_security_group.asg_security_group]
  

#   #   network_interfaces {
#   #     security_groups = [aws_security_group.security_group[0].id]
#   #   }

#   # tag_specifications {
#   #   resource_type = "instance"

#   #   tags = {
#   #     Name = "${each.key}-tf"
#   #   }
#   # }

# }

# resource "aws_autoscaling_group" "omega_asg" {
#   for_each = var.autoscaling_groups

#   launch_template {
#     id      = aws_launch_template.omega-lt[each.key].id
#     version = "$Latest"
#   }
#   name                      = each.value.name
#   max_size                  = each.value.max_size
#   min_size                  = each.value.min_size
#   health_check_grace_period = each.value.health_check_grace_period
#   health_check_type         = each.value.health_check_type
#   desired_capacity          = each.value.desired_capacity
#   force_delete              = each.value.force_delete
#   availability_zones        = each.value.availability_zones
#   depends_on = [aws_launch_template.omega-lt]
  
# }