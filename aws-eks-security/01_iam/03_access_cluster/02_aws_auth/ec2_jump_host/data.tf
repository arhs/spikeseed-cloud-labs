data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_default_tags" "aws_tags" {}

data "http" "k8s_latest_version" {
  url    = "https://dl.k8s.io/release/stable.txt"
  method = "GET"
}

data "aws_region" "current" {}
