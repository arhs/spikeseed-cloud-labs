resource "aws_lambda_function" "main" {
  filename         = data.archive_file.lambda_edge_cookie.output_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda_edge_role.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.lambda_edge_cookie.output_base64sha256

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [source_code_hash]
  }

  # Publish a new version when the function code changes
  publish = true
}

