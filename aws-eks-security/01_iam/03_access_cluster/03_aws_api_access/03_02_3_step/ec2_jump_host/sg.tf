resource "aws_security_group" "jump_host_sg" {
  description = "Allows access to the Jump host"
  name        = var.security_group_name
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    to_port          = 0
  }
  tags = {
    "Name" = var.security_group_name
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "cluster_ingress_jump_host" {
  description              = "Allow jump host communication"
  from_port                = 443
  protocol                 = "TCP"
  security_group_id        = var.cluster_security_group_id
  source_security_group_id = aws_security_group.jump_host_sg.id
  to_port                  = 443
  type                     = "ingress"
}
