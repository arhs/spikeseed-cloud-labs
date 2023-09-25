variable "cluster_create_timeout" {
  type    = string
  default = "30m"
}

variable "cluster_delete_timeout" {
  type    = string
  default = "15m"
}

variable "cluster_enabled_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_endpoint_public_access_cidrs" {
  type    = list(any)
  default = []
}

variable "cluster_log_retention_in_days" {
  type    = number
  default = 60
}

variable "cluster_name" {
  type = string
}

variable "cluster_update_timeout" {
  type    = string
  default = "60m"
}

variable "cluster_version" {
  type = string
}

#variable "kms_key_arn" {
#  description = "The kms key ARN to be used to encrypt EKS secrets"
#  type        = string
#}

variable "name_prefix" {
  description = "Define the prefix of the name to use on every resources"
  type        = string
}

variable "subnet_ids" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "workers_sg_allowed_cidrs" {
  type = list(string)
}

variable "ssm_prefix" {
  description = "Define the prefix of the name to use on every ssm parameters"
  type        = string
}

variable "create_cluster_role" {
  type = bool
  default = false
}

variable "eks_cluster_role_name" {
  type = string
}

variable "kms_policy" {
  type = string
}