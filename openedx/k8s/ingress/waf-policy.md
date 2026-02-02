# Sample WAF Policy (AWS WAF)

* AWSManagedRulesCommonRuleSet
* AWSManagedRulesKnownBadInputsRuleSet
* AWSManagedRulesSQLiRuleSet
* Rate-based rule: 2000 requests per 5 minutes per IP
* Geo-blocking for restricted regions (optional)

Attach WAF to CloudFront or ALB depending on your traffic flow design.
