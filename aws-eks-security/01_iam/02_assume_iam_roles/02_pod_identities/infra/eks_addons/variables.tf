variable "cluster_addons" {
  type    = map(any)
  default = {}
}

variable "cluster_version" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type = string
}
