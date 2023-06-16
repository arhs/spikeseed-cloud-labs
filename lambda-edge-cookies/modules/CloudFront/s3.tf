locals {
  bucket_arns = {
    for bucket in aws_s3_bucket.bucket : bucket.bucket => bucket.arn
  }
}

resource "aws_s3_bucket" "bucket" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = var.bucket_names[count.index]
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.bucket[count.index].bucket

  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = true
}


resource "null_resource" "wait_for_policy" {
  count = length(var.bucket_names)

  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [aws_s3_bucket.bucket]
}



resource "aws_s3_bucket_policy" "example_bucket_policy" {
  for_each = local.bucket_arns

  bucket = each.key

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${each.value}/*"]
      },
    ]
  })
   lifecycle {
    ignore_changes = [policy]
  }

  depends_on = [aws_s3_bucket.bucket]
}



# upload index.html files

resource "null_resource" "upload_files" {
  count = length(var.bucket_names)

  provisioner "local-exec" {
    command = <<EOT
      if [ ${count.index} -eq 0 ]; then
        aws s3 cp /home/hristost/bitbucket/lambda_edge_cookies/new/index.html s3://${aws_s3_bucket.bucket[count.index].bucket}
      else
        aws s3 cp /home/hristost/bitbucket/lambda_edge_cookies/old/index.html s3://${aws_s3_bucket.bucket[count.index].bucket}
      fi
    EOT
  }

  depends_on = [aws_s3_bucket.bucket]
}






