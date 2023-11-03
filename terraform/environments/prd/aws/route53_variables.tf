locals {
  route53 = {
    zone_name   = "omega.smodata.net"
    record_name = "old" # use short record cause FQDN is bad
    record_type = "A"
    cname_records = {
      "cname_record_1" = {
        cname_record_name  = "_01e2ef32201b630c6235becd840bc13a.api.omega.smodata.net"
        cname_record_type  = "CNAME"
        cname_record_ttl   = 300
        cname_record_value = ["_1d0e1bc1ff20d5ff88e555f5c778a0b2.vlvttdkdcz.acm-validations.aws."]
      }
    }
  }
  k8s_elb_dns = {
    a_record = {
      dns_name    = "api.omega.smodata.net"
      dns_type    = "A"
      alias = {
        dns_alias_name                   = "a52257f4003464781a79a0193c4284b9-301112538.eu-west-1.elb.amazonaws.com"
        dns_alias_evaluate_target_health = true
      }
    }
  }
}
