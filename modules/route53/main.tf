# Reference to the existing hosted zone
data "aws_route53_zone" "main" {
  name = var.domain_name
}

# Create A records for your services in the existing hosted zone
resource "aws_route53_record" "service_80_record" {
  zone_id = aws_route53_record.service_80_record.id
  name    = "wordpress.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = var.zone_id 
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "service_3000_record" {
  zone_id = aws_route53_record.service_80_record.id
  name    = "microservice.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = var.zone_id 
    evaluate_target_health = true
  }
}
