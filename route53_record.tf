resource "aws_route53_record" "record1" {
  zone_id = var.zone_id
  name    = var.route53_record_name
  type    = "A"
  alias {
    name                   = aws_lb.utc-app-alb.dns_name
    zone_id                = aws_lb.utc-app-alb.zone_id
    evaluate_target_health = true
  }
}