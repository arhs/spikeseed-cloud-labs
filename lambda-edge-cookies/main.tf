module "CloudFront" {
  source              = "./modules/CloudFront"
  lambda_arn          = module.lambda.lambda_function_arn
  lambda_version      = module.lambda.lambda_function_version
  acm_certificate_arn = module.acm.acm_certificate_arn
  bucket_names        = ["spikeseed-old", "spikeseed-new"]
  zone_id             = "Z3B54DM0BJJFD9"
  domain_name         = "edge.labs.spikeseed.cloud"
}



module "Lambda" {
  source = "./modules/Lambda"

  function_name = "lambda_edge_cookie"
  handler       = "lambda_edge_cookie.handler"
  runtime       = "nodejs14.x"
  timeout       = 5
  memory_size   = 128
}

module "ACM" {
  source                    = "./modules/ACM"
  zone_id                   = "Z3B54DM0BJJFD9"
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
  cloudfront_domain_name    = module.cloudfront.cloudfront_distribution.domain_name

}