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

# variable "record_ttl" {
#   description = "TTL Route53 record"
#   type        = number
# }

# variable "record_records" {
#   description = "records for the Route53 record"
#   type        = list(string)
# }


variable "cname_record_name" {
  description = "CNAME record name"
  type        = string
}

variable "cname_record_type" {
  description = "CNAME record type"
  type        = string
}

variable "cname_record_ttl" {
  description = "TTL CNAME record"
  type        = number
}

variable "cname_record_value" {
  description = "Value CNAME record"
  type        = list(string)
}

