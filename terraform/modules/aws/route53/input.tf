variable "lb_dns_name" {
}

variable "lb_zone_id" {
}

variable "zone_name" {
  description = "Route53 zone"
  type        = string
}

variable "record_name" {
  description = "Route53 record"
  type        = string
}

variable "record_type" {
  description = "Route53 record"
  type        = string
}

variable "cname_records" {
  description = "Map of CNAME records"
  type = map(object({
    cname_record_name  = string
    cname_record_type  = string
    cname_record_ttl   = number
    cname_record_value = list(string)
  }))
}

variable "k8s_elb_dns" {
  description = "Map of eks a-record"
  type = map(object({
    dns_name = string
    dns_type    = string
    alias = object({
      dns_alias_name                   = string
      dns_alias_evaluate_target_health = bool
    })
  }
  ))
}