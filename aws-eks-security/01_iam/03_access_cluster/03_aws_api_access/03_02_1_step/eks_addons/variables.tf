variable "cluster_addons" {
  default = {}
  type    = map(any)
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  default = ""
  type    = string
}
