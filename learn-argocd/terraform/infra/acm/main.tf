resource "aws_acm_certificate" "application" {
  domain_name       = var.application_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "application" {
  for_each = {
    for dvo in aws_acm_certificate.application.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "application" {
  certificate_arn         = aws_acm_certificate.application.arn
  validation_record_fqdns = [for record in aws_route53_record.application : record.fqdn]
}

resource "aws_acm_certificate" "argocd" {
  domain_name       = var.argocd_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "argocd" {
  for_each = {
    for dvo in aws_acm_certificate.argocd.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "argocd" {
  certificate_arn         = aws_acm_certificate.argocd.arn
  validation_record_fqdns = [for record in aws_route53_record.argocd : record.fqdn]
}