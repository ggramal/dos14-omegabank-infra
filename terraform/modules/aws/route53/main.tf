

resource "aws_route53_zone" "omega" {
  name = var.zone_name
}

resource "aws_route53_record" "record" {

  zone_id = aws_route53_zone.omega.id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "eks-A-record" {
  for_each = var.eks
  zone_id = aws_route53_zone.omega.id
  name    = each.value.eks_name
  type    = each.value.eks_type

  alias {
    name                   = each.value.alias_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = each.value.alias_evaluate_target_health
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