variable "cluster_name" {
  description = "The ID of the cluster where the ingress controller should be attached"
  type        = string
}

variable "admin_users_role_arn" {
  type = string
}

variable "worker_node_role_arn" {
  type = string
}
