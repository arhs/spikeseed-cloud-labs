variable "service_account_name" {
  type    = string
  default = "aws-load-balancer-controller"
}

variable "namespace" {
  type    = string
  default = "kube-system"
}
