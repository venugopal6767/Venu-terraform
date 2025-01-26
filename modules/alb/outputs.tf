output "alb_arn" {
  value = aws_lb.app_lb.arn
  description = "The ARN of the Application Load Balancer"
}

output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

# ALB Output for Zone ID
output "alb_zone_id" {
  value = aws_lb.app_lb.zone_id
  description = "The zone ID of the Application Load Balancer"
}