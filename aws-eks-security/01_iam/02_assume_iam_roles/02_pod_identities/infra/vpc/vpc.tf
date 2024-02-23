resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.name
  }
}

resource "aws_default_security_group" "this" {
  tags = {
    Name = "${var.name}-vpc-default-unused"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  tags = {
    Name = "${var.name}-default-unused"
  }
}

resource "aws_internet_gateway" "this" {
  tags = {
    Name = var.name
  }
  vpc_id = aws_vpc.this.id
}
