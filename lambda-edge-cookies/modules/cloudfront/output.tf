output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.cloudfront_distribution
}
