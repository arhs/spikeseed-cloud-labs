#--------------------------
# Cluster
#--------------------------

resource "aws_security_group" "cluster" {
  #checkov:skip=CKV2_AWS_5:Security Groups are used to limit the access to the cluster
  name        = "${var.name_prefix}-eks-cluster"
  description = "EKS cluster security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-eks-cluster"
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  security_group_id = aws_security_group.cluster.id
  description       = "Allow cluster egress access to the Internet."
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_1" {
  security_group_id        = aws_security_group.cluster.id
  description              = "Allow cluster resources communication"
  type                     = "ingress"
  source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_2" {
  security_group_id        = aws_security_group.cluster.id
  description              = "Allow cluster resources communication"
  type                     = "ingress"
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "cluster_ingress_cluster_3" {
  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description              = "Allow cluster resources communication"
  type                     = "ingress"
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

### =====================================================
### Remove below
### =====================================================

resource "aws_security_group_rule" "cluster_ingress_workers" {
  security_group_id        = aws_security_group.cluster.id
  description              = "Allow pods running on workers to send communication from the cluster control plane (e.g. Fargate pods)."
  type                     = "ingress"
  source_security_group_id = aws_security_group.workers.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
}

#--------------------------
# Workers / Fargate
#--------------------------

resource "aws_security_group" "workers" {
  #checkov:skip=CKV2_AWS_5:Security Groups are used to limit the access to the cluster
  name        = "${var.name_prefix}-eks-workers"
  description = "Security group for all nodes in the cluster."
  vpc_id      = var.vpc_id

  tags = {
    "Name"                                      = "${var.name_prefix}-eks-workers"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "workers_egress_internet" {
  security_group_id = aws_security_group.workers.id
  description       = "Allow nodes all egress to the Internet."
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  security_group_id        = aws_security_group.workers.id
  description              = "Allow nodes to communicate with each other."
  type                     = "ingress"
  source_security_group_id = aws_security_group.workers.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  security_group_id        = aws_security_group.workers.id
  description              = "Allow workers pods or pods running on workers to receive communication from the cluster control plane."
  type                     = "ingress"
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 0 #1025 (without fargate)
  to_port                  = 65535
  protocol                 = "all"
}

resource "aws_security_group_rule" "workers_ingress_http" {
  security_group_id = aws_security_group.workers.id
  description       = "Allow node access from HTTP"
  type              = "ingress"
  cidr_blocks       = var.workers_sg_allowed_cidrs
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "workers_ingress_https" {
  security_group_id = aws_security_group.workers.id
  description       = "Allow node access from HTTPS"
  type              = "ingress"
  cidr_blocks       = var.workers_sg_allowed_cidrs
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}
