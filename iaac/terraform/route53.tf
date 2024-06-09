data "aws_route53_zone" "primary" {
  name = "devopspraksans2024.com"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.primary.name
  subject_alternative_names = ["*.devopspraksans2024.com"]
  validation_method = "DNS"

  tags = {
    Name        = "app-acm-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "validation_records" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_records : record.fqdn]
}


resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "alb"
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = aws_api_gateway_domain_name.api_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.api_domain.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.api_domain.regional_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "front_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "front"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf.domain_name
    zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
    evaluate_target_health = true
  }
}