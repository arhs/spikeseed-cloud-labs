output "lambda_function_arn" {
  value = aws_lambda_function.main.arn
}

output "lambda_function_version" {
  value = aws_lambda_function.main.version
}
