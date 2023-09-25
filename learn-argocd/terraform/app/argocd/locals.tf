locals {
  argocd = {
    extra_args = concat(var.extra_args, [var.insecure ? "--insecure" : ""])
    ingress = {
      acm_cert_arn = "arn:aws:acm:eu-west-1:820263751386:certificate/57c7081e-9b7d-4ffc-8048-a27597f69649"
      waf_profile_arn = "arn:aws:wafv2:eu-west-1:820263751386:regional/webacl/argocd-demo-waf/9b8e318e-40d0-41d8-8036-60793b5ae761"
    }
  }
  extra_args = concat(var.extra_args, [var.insecure ? "--insecure" : ""])
}