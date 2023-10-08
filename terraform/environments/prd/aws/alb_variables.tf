locals {
  name               = "ALB"
  internal           = "false"
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  sg_name            = "sg_alb"
  sg_description     = "Allow 80 and 443 inbound traffic to ALB"
  sg_rules_ingress = {
    ports = [
      {
        port        = 80
        protocol    = "TCP"
        description = "http from internet"
      },
      {
        protocol    = "TCP"
        port        = 443
        description = "https from internet"
      }
    ]
    cidrs_ipv4 = ["0.0.0.0/0"]
  }
  sg_rules_egress = {
    ports = [
      {
        port        = 0
        protocol    = "-1"
        description = "all"
      }
    ]
    cidrs_ipv4 = ["0.0.0.0/0"]
  }
  tgs_alb = {
    authz = {
      port     = 80
      protocol = "HTTP"
      path     = "/api/v1/authz/health_check"
      matcher  = 200
    }
    authn = {
      port     = 80
      protocol = "HTTP"
      path     = "/api/v1/authn/health_check"
      matcher  = 200
    }
    bank = {
      port     = 80
      protocol = "HTTP"
      path     = "/api/v1/bank/health_check"
      matcher  = 200
    }
  }
  tg_lb_type = "instance"

  listener_http = {
    port               = 80
    protocol           = "HTTP"
    action_type        = "redirect"
    action_port        = 443
    action_protocol    = "HTTPS"
    action_status_code = "HTTP_301"
  }

  listener_https = {
    port            = 443
    protocol        = "HTTPS"
    ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn = local.cert
    action_type     = "forward"
  }

  rules = [
    {
      name        = "authz"
      priority    = 99
      type        = "forward"
      path_values = ["/api/v1/users/*", "/api/v1/organisations/*", "/api/v1/users", "/api/v1/organisations", "/api/v1/?*/authz/?*"]
    },
    {
      name        = "authn"
      priority    = 98
      type        = "forward"
      path_values = ["/api/v1/identity/validate", "/api/v1/identity/login", "/api/v1/identity"]
    },
    {
      name        = "bank"
      priority    = 97
      type        = "forward"
      path_values = ["/api/v1/credits/*", "/api/v1/deposits/*", "/api/v1/deposits", "/api/v1/credits"]
    }
  ]
  cert = "arn:aws:acm:eu-west-1:546240550610:certificate/1a5a24e5-95ba-44f5-a456-08401c724647"
}
