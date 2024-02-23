output "jump_host_iam_role_arn" {
  value = aws_iam_role.jump_host.arn
}

output "jump_host_instance_profile_role_arn" {
  value = aws_iam_instance_profile.jump_host.arn
}
