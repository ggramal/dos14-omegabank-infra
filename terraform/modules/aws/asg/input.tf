variable "private_subnet_ids" {
  type = list(string)
}


variable "asg_services" {
  type = map(object(
    {
      lt = object({
        name          = string
        path          = string
        instance_type = string
        key_name      = string
        git_branch = string
        secrets = string
      })
      asg = object({
        name             = string
        desired_capacity = number
        min_size         = number
        max_size         = number
        tg_alb           = any
      })
    }
  ))
}


variable "asg_sg" {
  description = "Security group for asg"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(set(string))
    sg_id = optional(string)
  }))
}

variable "vpc_id" {
  description = "Get vpc id"
}

