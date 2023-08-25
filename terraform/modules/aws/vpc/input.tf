variable "name" {
  description = "Vpc name"
  type        = string
}

variable "cidr" {
  description = "Vpc cidr"
  type        = string
}

variable "internet_gws" {
  description = "Vpc internate gateway"
  type = map(
    object(
      {
        name = string
      }
    )
  )
}


variable "nat_gws" {
  description = "Vpc nat gateway"
  type = map(
    object(
      {
        name = string
      }
    )
  )
}


variable "subnets" {
  description = "Vpc subnets"
  type = map(
    object(
      {
        name                = string
        cidr                = string
        public_ip_on_launch = optional(bool, false)
        availability_zone   = string
        routes = list(
          object(
            {
              cidr        = string
              internet_gw = optional(string)
              nat_gw      = optional(string)
            }
          )
        )

      }
    )
  )
}