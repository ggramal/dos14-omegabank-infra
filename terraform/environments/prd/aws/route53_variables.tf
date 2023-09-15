locals {
  route53 = {
    zone_name       = "omega.smodata.net"
    record_name     = "api.omega.smodata.net"
    record_type     = "A"
    cname_records = {
      "cname_record_1" = {
        cname_record_name   = "_01e2ef32201b630c6235becd840bc13a.api.omega.smodata.net"
        cname_record_type   = "CNAME"
        cname_record_ttl    = 300
        cname_record_value  = ["_1d0e1bc1ff20d5ff88e555f5c778a0b2.vlvttdkdcz.acm-validations.aws."]
      },
      "cname_record_2" = {
        cname_record_name   = "_01e2ef32201b630c6235becd840bc13a.test.net"
        cname_record_type   = "CNAME"
        cname_record_ttl    = 300
        cname_record_value  = ["_1d0e1bc1ff20d5ff88e555f5c778a0b2.test.net"]
      }
      // Добавьте дополнительные записи CNAME по вашему желанию
    }
  }
}
