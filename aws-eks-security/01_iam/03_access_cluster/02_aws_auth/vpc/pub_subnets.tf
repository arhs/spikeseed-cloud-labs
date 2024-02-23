resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  availability_zone       = local.az_names[count.index]
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
    "Name"                   = "${var.name}-public-az${var.azs[count.index]}",
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  tags = {
    Name = "${var.name}-public-az"
  }
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public_internet_gateway" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = aws_route_table.public.id
  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}
