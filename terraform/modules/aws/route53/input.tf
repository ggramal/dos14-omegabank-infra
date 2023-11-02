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

variable "eks" {
  description = "Map of eks a-record"
  type = map(object({
    eks_name = string
    eks_type    = string
    alias_name                   = string
    alias_evaluate_target_health = bool
  }
  ))
}