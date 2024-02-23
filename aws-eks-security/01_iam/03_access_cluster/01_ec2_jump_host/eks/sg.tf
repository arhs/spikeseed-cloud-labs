resource "aws_security_group" "cluster" {
  name        = "${var.name_prefix}-eks-cluster"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-eks-cluster"
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow cluster egress access to the Internet."
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_1" {
  description              = "Allow cluster resources communication"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_2" {
  description              = "Allow cluster resources communication"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.cluster.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_3" {
  description              = "Allow cluster resources communication"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.cluster.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_ingress_workers" {
  description              = "Allow pods running on workers to send communication from the cluster control plane (e.g. Fargate pods)."
  from_port                = 0
  protocol                 = "all"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.workers.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group" "workers" {
  description = "Security group for all nodes in the cluster."
  name        = "${var.name_prefix}-eks-workers"
  vpc_id      = var.vpc_id

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Name"                                      = "${var.name_prefix}-eks-workers"
  }
}

resource "aws_security_group_rule" "workers_egress_internet" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow nodes all egress to the Internet."
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.workers.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  description              = "Allow nodes to communicate with each other."
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.workers.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  description              = "Allow workers pods or pods running on workers to receive communication from the cluster control plane."
  from_port                = 1025 #0 #1025 (without fargate)
  protocol                 = "all"
  security_group_id        = aws_security_group.workers.id
  source_security_group_id = aws_security_group.cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_http" {
  cidr_blocks       = var.workers_sg_allowed_cidrs
  description       = "Allow node access from HTTP"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.workers.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_https" {
  cidr_blocks       = var.workers_sg_allowed_cidrs
  description       = "Allow node access from HTTPS"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.workers.id
  to_port           = 443
  type              = "ingress"
}
