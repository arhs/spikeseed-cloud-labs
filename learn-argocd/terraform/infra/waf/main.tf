resource "aws_wafv2_web_acl" "main" {

  name  = "${var.name_prefix}-waf"
  scope = var.scope

  default_action {
    allow {}
  }

  # https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html
  rule {
    name     = "AWSCommonRules"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "AWSKnownBadInputsRules"
    priority = 2

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = false
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF"
    sampled_requests_enabled   = false
  }

}
