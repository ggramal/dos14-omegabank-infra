resource "aws_security_group" "asg_security_group" {
  for_each = var.security_group
  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
#    for_each = var.security_group
    for_each = [
    for ingress in each.value.ingress:
    ingress
    ]
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }

  }
}

resource "aws_launch_template" "omega-lt" {
  for_each               = var.launch_template
  name                   = each.value.name
  image_id               = each.value.image_id
  instance_type          = each.value.instance_type
  key_name               = each.value.key
#  vpc_security_group_ids = [aws_security_group.asg_security_group[each.key].id]
  vpc_security_group_ids = ["sg-0cc962110b7f60649"]
  user_data              = each.value.user_data
  depends_on = [aws_security_group.asg_security_group]

  #   network_interfaces {
  #     security_groups = [aws_security_group.security_group[0].id]
  #   }

  # tag_specifications {
  #   resource_type = "instance"

  #   tags = {
  #     Name = "${each.key}-tf"
  #   }
  # }

}

resource "aws_autoscaling_group" "omega_asg" {
  for_each = var.autoscaling_groups

  launch_template {
    id      = aws_launch_template.omega-lt[each.key].id
    version = "$Latest"
  }
  name                      = each.value.name
  max_size                  = each.value.max_size
  min_size                  = each.value.min_size
  health_check_grace_period = each.value.health_check_grace_period
  health_check_type         = each.value.health_check_type
  desired_capacity          = each.value.desired_capacity
  force_delete              = each.value.force_delete
  availability_zones        = each.value.availability_zones
  depends_on = [aws_launch_template.omega-lt]
}