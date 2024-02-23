variable "cluster_name" {
  type = string
}

variable "cluster_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "instance_type" {
  default = "t3.micro"
  type    = string
}

variable "name_prefix" {
  type = string
}

variable "role_name" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
