resource "aws_iam_policy" "alb_controller" {
  description = "The ALB controller policy"
  name        = local.alb_controller_policy_name
  path        = "/"
  policy      = file("${path.module}/iam_policy.json")
}

resource "aws_iam_role" "alb_controller" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
  name = local.alb_controller_role_name
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}
