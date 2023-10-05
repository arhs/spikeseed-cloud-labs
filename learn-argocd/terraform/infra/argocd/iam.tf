resource "aws_iam_role" "argocd" {
  name = var.argocd_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = [
              "system:serviceaccount:${var.namespace}:${var.release_name}-repo-server"
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "argocd" {
  name = "${var.argocd_role_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "argocd" {
  role       = aws_iam_role.argocd.name
  policy_arn = aws_iam_policy.argocd.arn
}