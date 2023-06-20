resource "aws_iam_role" "lambda_edge_role" {
  name = "lambda_edge_cookies1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_edge_policy" {
  name_prefix = "lambda_edge_policy1"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "cloudfront:*",
          "lambda:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  role = aws_iam_role.lambda_edge_role.id
}

