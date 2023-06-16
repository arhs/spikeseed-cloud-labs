data "archive_file" "lambda_edge_cookie" {
  type        = "zip"
  source_dir  = "${path.module}/template"
  output_path = "${path.module}/lambda_edge_cookie.zip"
}