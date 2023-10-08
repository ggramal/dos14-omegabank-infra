output "lb_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.omega.id, "")
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.omega.arn, "")
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.omega.dns_name
}

output "lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(aws_lb.omega.arn_suffix, "")
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(aws_lb.omega.zone_id, "")
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created"
  value       = aws_lb_listener.frontend_http[*].arn
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created"
  value       = aws_lb_listener.frontend_http[*].id
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created"
  value       = aws_lb_listener.frontend_https[*].arn
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created"
  value       = aws_lb_listener.frontend_https[*].id
}

output "tg_bank_arn" {
  value = [
    for tg_key, tg_obj in aws_lb_target_group.tgs :
    tg_obj.arn
    if length(regexall("bank", tg_key)) > 0
  ]
}

output "tg_authz_arn" {
  value = [
    for tg_key, tg_obj in aws_lb_target_group.tgs :
    tg_obj.arn
    if length(regexall("authz", tg_key)) > 0
  ]
}

output "tg_authn_arn" {
  value = [
    for tg_key, tg_obj in aws_lb_target_group.tgs :
    tg_obj.arn
    if length(regexall("authn", tg_key)) > 0
  ]
}

#output "target_group_arns" {
#  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group"
#  value       = aws_lb_target_group.tgs[*].arn
#}
#
#output "target_group_arn_suffixes" {
#  description = "ARN suffixes of our target groups - can be used with CloudWatch"
#  value       = aws_lb_target_group.tgs[*].arn_suffix
#}
#
#output "target_group_names" {
#  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group"
#  value       = aws_lb_target_group.tgs[*].name
#}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = try(aws_security_group.alb_sg.arn, null)
}

output "alb_security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.alb_sg.id, null)
}