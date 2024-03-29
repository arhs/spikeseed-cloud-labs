output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "public_subnets_ids" {
  value = join(",", [for id in aws_subnet.public[*].id: id])
}

output "private_subnets_ids" {
  value = join(",", [for id in aws_subnet.private[*].id: id])
}


output "private_subnets_arns" {
  value = join(",", [for arn in aws_subnet.private[*].arn: arn])
}