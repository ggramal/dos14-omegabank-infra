
# provider "aws" {
#   region = "eu-central-1"
# }

resource "aws_route53_zone" "omega" {
  name = var.zone_name
}

resource "aws_route53_record" "record" {

  zone_id = aws_route53_zone.omega.id
  name    = var.record_name
  type    = var.record_type

  #we don’t have alb, I specified entries in the alias of the current A record, then we will change it to substitute the values of alb.
   alias {
     name = "dualstack.alb-omega-2144136904.eu-west-1.elb.amazonaws.com."
     zone_id = aws_route53_zone.omega.id
     evaluate_target_health = true  
     }
 }

resource "aws_route53_record" "cname_record" {
  for_each = var.cname_records
  zone_id  = aws_route53_zone.omega.id
  name     = each.value.cname_record_name
  type     = each.value.cname_record_type
  ttl      = each.value.cname_record_ttl
  records  = each.value.cname_record_value
}