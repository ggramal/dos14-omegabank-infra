variable "security_group" {
  type = map(
    object(
      {
        name        = string
        description = string
        ingress = list(
          object(
            {
              description = string
              from_port   = number
              to_port     = number
              protocol    = string
              cidr_blocks = list(string)
            }
          )
        )
      }
    )
  )
}

variable "launch_template" {
  description = "launch_template"
  type = map(
    object(
      {
        name          = string
        image_id      = string
        instance_type = string
        key           = string
        user_data     = string
      }
    )
  )
}


variable "autoscaling_groups" {
  type = map(
    object(
      {
        name                      = string
        launch_template_id        = string
        max_size                  = number
        min_size                  = number
        health_check_grace_period = number
        health_check_type         = string
        desired_capacity          = number
        force_delete              = bool
        availability_zones        = list(string)
      }
    )
  )
}

# # variable "asg_security_group_id" {
# # }

# # variable "launch_template_id" {
# # }

 variable "vpc_id" {
 }

# variable "subnet_ids" {
# }