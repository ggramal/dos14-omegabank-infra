resource "aws_lb" "omega" {
  name               = var.name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  subnets            = var.public_subnet_ids

  ip_address_type = var.ip_address_type
}

resource "aws_lb_target_group" "tgs" {
  for_each = var.alb_tgs
  name     = each.key
  vpc_id   = var.vpc_id
  port     = each.value.port
  protocol = each.value.protocol

  target_type = var.tg_lb_type

  dynamic "health_check" {
    for_each = try([var.alb_tgs[each.key].health_check], [])

    content {
      path    = try(health_check.value.path, null)
      matcher = try(health_check.value.matcher, null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "omega-tf" {
  count        = length(var.rules)
  listener_arn = aws_lb_listener.frontend_https.arn
  priority     = var.rules[count.index].priority

  action {
    type             = var.rules[count.index].type
    target_group_arn = aws_lb_target_group.tgs[var.rules[count.index].name].arn
  }

  condition {
    path_pattern {
      values = var.rules[count.index].path_values
    }
  }
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.omega.arn

  port     = var.listener_http["port"]
  protocol = var.listener_http["protocol"]

  default_action {
    type = var.listener_http["action_type"]
    redirect {
      port        = var.listener_http["action_port"]
      protocol    = var.listener_http["action_protocol"]
      status_code = var.listener_http["action_status_code"]
    }
  }
}

resource "aws_lb_listener" "frontend_https" {
  load_balancer_arn = aws_lb.omega.arn

  port            = var.listener_https.port
  protocol        = var.listener_https.protocol
  certificate_arn = var.listener_https.certificate_arn
  ssl_policy      = var.listener_https.ssl_policy

  default_action {
    type = var.listener_https.action_type
    target_group_arn = aws_lb_target_group.tgs["authz"].arn
  }
}

resource "aws_lb_listener_certificate" "https_cert" {
  listener_arn    = aws_lb_listener.frontend_https.arn
  certificate_arn = var.extra_ssl_certs
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "alb_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  dynamic "ingress" {
    for_each = var.sg_rules_ingress.ports

    content {
      description = var.sg_rules_ingress.ports[ingress.key].description
      from_port   = var.sg_rules_ingress.ports[ingress.key].port
      to_port     = var.sg_rules_ingress.ports[ingress.key].port
      protocol    = var.sg_rules_ingress.ports[ingress.key].protocol
      cidr_blocks = var.sg_rules_ingress.cidrs_ipv4
    }
  }
}