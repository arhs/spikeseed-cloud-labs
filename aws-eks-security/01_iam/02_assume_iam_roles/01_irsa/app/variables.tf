variable "cluster_oidc_issuer_url" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "secure-eks"
}

variable "oidc_provider_arn" {
  type = string
}

variable "service_account_name" {
  type    = string
  default = "aws-load-balancer-controller"
}
