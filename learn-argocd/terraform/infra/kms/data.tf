#data "aws_caller_identity" "current" {}
#
#data "aws_ssm_parameter" "eks_cluster_role_arn" {
#  name = var.ssm_eks_cluster_role_arn_key
#}

#data "aws_iam_policy_document" "ebs_decryption" {
#
#  statement {
#    sid    = "Enable IAM User Permissions"
#    effect = "Allow"
#
#    principals {
#      type        = "AWS"
#      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#    }
#
#    actions = ["kms:*"]
#
#    resources = ["*"]
#  }
#
#  statement {
#    sid    = "Allow service-linked role use of the customer managed key"
#    effect = "Allow"
#
#    principals {
#      type = "AWS"
#      identifiers = [
#        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
#        data.aws_ssm_parameter.eks_cluster_role_arn.value,
#      ]
#    }
#
#    actions = [
#      "kms:Encrypt",
#      "kms:Decrypt",
#      "kms:ReEncrypt*",
#      "kms:GenerateDataKey*",
#      "kms:DescribeKey"
#    ]
#
#    resources = ["*"]
#  }
#
#  statement {
#    sid    = "Allow attachment of persistent resources"
#    effect = "Allow"
#
#    principals {
#      type = "AWS"
#      identifiers = [
#        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
#        data.aws_ssm_parameter.eks_cluster_role_arn.value,
#      ]
#    }
#
#    actions = [
#      "kms:CreateGrant",
#      "kms:ListGrants",
#      "kms:RevokeGrant"
#    ]
#
#    resources = ["*"]
#
#    condition {
#      test     = "Bool"
#      variable = "kms:GrantIsForAWSResource"
#      values   = ["true"]
#    }
#  }
#}