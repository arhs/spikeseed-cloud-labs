variable "alb_controller_service_account_name" {
  type = string
}

variable "alb_controller_role_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

#variable "cw_agent_service_account_name" {
#  type = string
#  default = "cloudwatch-agent"
#}

#variable "cw_agent_role_name" {
#  type = string
#}

variable "external_dns_controller_role_name" {
  type = string
}

variable "external_dns_service_account_name" {
  type = string
}

#variable "fluentbit_role_name" {
#  type = string
#}

#variable "fluentbit_service_account_name" {
#  type = string
#}

#variable "name_prefix" {
#  type = string
#}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

#variable "aws_efs_csi_service_account_name" {
#  type    = string
#  default = "efs-csi-controller-sa"
#}