locals {
  extra_args = concat(var.extra_args, [var.insecure ? "--insecure" : ""])
}