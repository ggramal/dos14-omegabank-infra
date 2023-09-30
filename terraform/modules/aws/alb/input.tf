variable "vpc_id" {
  description = "vpc id"
  #  type = string
}

variable "public_subnet_ids" {
  description = "vpc public subnet ids"
}

variable "extra_ssl_certs" { #Нужен ARN сертификата
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate
}

variable "name" {
  description = "alb name"
  type        = string
}

variable "internal" {
  description = "internal or not alb"
  type        = bool
}

variable "load_balancer_type" {
  description = "type of load balancer to create"
  type        = string
}

variable "ip_address_type" {
  description = "type of IP addresses used by subnets"
  type        = string
}

variable "sg_name" {
  description = "alb security group name"
  type        = string
}

variable "sg_description" {
  description = "description for alb security group"
  type        = string
}

variable "sg_rules_ingress" {
  description = "ingress rules for alb security group"
  type = object(
    {
      ports = list(
        object(
          {
            port        = number
            protocol    = string
            description = string
          }
        )
      )
      cidrs_ipv4 = list(string)
    }
  )
}

variable "alb_tgs" {
  description = "alb target groups"
  type = map(
    object(
      {
        port     = number
        protocol = string
        path     = string
        matcher  = number
      }
    )
  )
}

variable "tg_lb_type" {
  description = "type of lb"
  type        = string
}

variable "listener_http" {
  description = "Load Balancer Listener http port80 variables"
  type = object(
    {
      port               = number
      protocol           = string
      action_type        = string
      action_port        = number
      action_protocol    = string
      action_status_code = string
    }
  )
}

variable "listener_https" {
  description = "Load Balancer Listener https port443 variables"
  type = object(
    {
      port            = number
      protocol        = string
      action_type     = string
      ssl_policy      = string
      certificate_arn = string
    }
  )
}

variable "rules" {
  description = "alb listeners rules"
  type = list(
    object(
      {
        name        = string
        priority    = number
        type        = string
        path_values = set(string)
      }
    )
  )
}