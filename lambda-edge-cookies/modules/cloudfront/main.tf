resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled = true

  aliases = [
    var.domain_name,
  ]

  origin {
    domain_name = aws_s3_bucket.bucket[0].website_endpoint
    origin_id   = "s3-${aws_s3_bucket.bucket[0].id}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.bucket[1].website_endpoint
    origin_id   = "s3-${aws_s3_bucket.bucket[1].id}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }
  }

  default_cache_behavior {
    target_origin_id = "s3-${aws_s3_bucket.bucket[0].id}"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward           = "whitelist"
        whitelisted_names = ["version"]
      }
    }


    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    # default_ttl = 3600
    # max_ttl =    86400

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = "${var.lambda_arn}:${var.lambda_version}"
      include_body = false
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
