
# provider "aws" {
#   region = "eu-central-1"
# }

resource "aws_route53_zone" "omega" {
  name = var.zone_name
}

resource "aws_route53_record" "record" {

  zone_id = aws_route53_zone.omega.zone_id
  name    = var.record_name
  type    = var.record_type
  #ttl     = var.record_ttl
  #records = var.record_records

  #we don’t have alb, I specified entries in the alias of the current A record, then we will change it to substitute the values of alb.
   alias {
     name = "dualstack.alb-omega-2144136904.eu-west-1.elb.amazonaws.com."
     zone_id = "eu-west-1"
     evaluate_target_health = true  
     }
 }

resource "aws_route53_record" "cname_record" {
  zone_id = aws_route53_zone.omega.zone_id
  name    = var.cname_record_name
  type    = var.cname_record_type
  ttl     = var.cname_record_ttl
  records = var.cname_record_value
}