variable "additional_tags" {
  default = []
  type    = list(any)
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "k8s_labels" {
  default = {}
  type    = map(string)
}

variable "metadata_options" {
  default = {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_protocol_ipv6          = optional(string, "disabled")
    http_put_response_hop_limit = number
    http_tokens                 = optional(string, "optional")
    instance_metadata_tags      = optional(string, "enabled")
  })
}

variable "ng_ami_type" {
  type = string
}

variable "ng_create_timeout" {
  default = "30m"
  type    = string
}

variable "ng_delete_timeout" {
  default = "15m"
  type    = string
}

variable "ng_desired_capacity" {
  type = number
}

variable "ng_max_capacity" {
  type = number
}

variable "ng_min_capacity" {
  type = number
}

variable "ng_update_default_version" {
  default = true
  type    = bool
}

variable "ng_update_timeout" {
  default = "60m"
  type    = string
}

variable "node_group_name" {
  type = string
}

variable "subnets" {
  type = string
}

variable "workers_disk_iops" {
  default = null
  type    = number
}

variable "workers_disk_size" {
  default = null
  type    = number
}

variable "workers_disk_throughput" {
  default = null
  type    = string
}

variable "workers_disk_type" {
  default = "gp3"
  type    = string
}

variable "workers_ebs_optimized" {
  default = true
  type    = bool
}

variable "workers_enable_monitoring" {
  default = true
  type    = bool
}

variable "workers_instance_type" {
  type = string
}

variable "workers_max_unavailable" {
  default = null
  type    = number
}

variable "workers_max_unavailable_percentage" {
  type = number
}

variable "workers_role_arn" {
  type = string
}

variable "workers_security_group_id" {
  type = string
}
