variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_profile_name" {
  type = string
}

variable "role_name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_security_group_id" {
  type = string
}