variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "ng_create_timeout" {
  type    = string
  default = "30m"
}

variable "ng_delete_timeout" {
  type    = string
  default = "15m"
}

variable "ng_update_timeout" {
  type    = string
  default = "60m"
}

#variable "ssm_vpc_id_key" {
#  type = string
#}

variable "subnets" {
  type = string
}

variable "workers_security_group_id" {
  type = string
}

variable "node_group_name" {
  type = string
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
variable "ng_ami_type" {
  type = string
}

variable "ng_update_default_version" {
  type    = bool
  default = true
}

variable "workers_role_arn" {
  type = string
}

variable "workers_max_unavailable_percentage" {
  type = number
}

variable "workers_max_unavailable" {
  type    = number
  default = null
}

variable "workers_disk_size" {
  type    = number
  default = null
}

variable "workers_disk_type" {
  type    = string
  default = "gp3"
}

variable "workers_disk_iops" {
  type    = number
  default = null
}

variable "workers_disk_throughput" {
  type    = string
  default = null
}

variable "workers_ebs_optimized" {
  type    = bool
  default = true
}

variable "workers_instance_type" {
  type = string
}

variable "workers_enable_monitoring" {
  type    = bool
  default = true
}

variable "k8s_labels" {
  type    = map(string)
  default = {}
}

variable "additional_tags" {
  type    = list(any)
  default = []
}