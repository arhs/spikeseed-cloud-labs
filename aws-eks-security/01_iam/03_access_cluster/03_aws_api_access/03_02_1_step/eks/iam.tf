resource "aws_iam_group" "admin_group" {
  name = "${var.name_prefix}-eks-admins"
}

resource "aws_iam_group_policy_attachment" "admin_group_policy_attachement" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.eks_admin_group.arn
}

resource "aws_iam_group_policy_attachment" "admin_group_policy_attachement_secretsmanager" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_group_policy_attachment" "admin_group_policy_attachement_ssm" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count = var.create_oidc_provider ? 1 : 0

  client_id_list = ["sts.amazonaws.com"]
  tags = {
    Name = "${var.cluster_name}-eks-irsa"
  }
  thumbprint_list = concat([data.tls_certificate.cluster.certificates[0].sha1_fingerprint])
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_policy" "eks_admin_group" {
  name   = "${var.name_prefix}-eks-admin-group"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_admin_users_role.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "eks_admin_users_policy" {
  name   = "${var.name_prefix}-eks-admin-users-policy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:Describe*",
                "eks:List*",
                "eks:Read*",
                "iam:ListRoles",
                "eks:AccessKubernetesApi"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "eks_admin_users_role" {
  name = "${var.name_prefix}-eks-admin-users-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role" "eks_worker_node_role" {
  name = "${var.name_prefix}-eks-worker-node-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_users_policy_attachement" {
  policy_arn = aws_iam_policy.eks_admin_users_policy.arn
  role       = aws_iam_role.eks_admin_users_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_service_policy_attachement" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attachement_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attachement_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attachement_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_attachement_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_worker_node_role.name
}
