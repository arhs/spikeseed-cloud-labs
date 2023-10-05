output "argocd_cert_arn" {
  value = aws_acm_certificate.argocd.arn
}

output "application_cert_arn" {
  value = aws_acm_certificate.application.arn
}