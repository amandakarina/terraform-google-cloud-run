variable "default_rules" {
    description = "Default rule for cloud armor"
    default = {
        default_rule = {
            action         = "allow"
            priority       = "2147483647"
            versioned_expr = "SRC_IPS_V1"
            src_ip_ranges  = ["*"]
            description    = "Default allow all rule"
        }
    }
    type = map(object({
        action         = string
        priority       = string
        versioned_expr = string
        src_ip_ranges  = list(string)
        description    = string
    }))
}

 variable "owasp_rules" {
     description = "value"
     default = {
         rule_sqli = {
             action = "deny(403)"
             priority = "1000"
             expression = "evaluatePreconfiguredExpr('sqli-stable', ['owasp-crs-v030001-id942251-sqli', 'owasp-crs-v030001-id942420-sqli', 'owasp-crs-v030001-id942431-sqli', 'owasp-crs-v030001-id942460-sqli', 'owasp-crs-v030001-id942421-sqli', 'owasp-crs-v030001-id942432-sqli'])"
         }
         rule_xss = {
             action = "deny(403)"
             priority = "1001"
             expression = "evaluatePreconfiguredExpr('xss-stable', ['owasp-crs-v030001-id941150-xss', 'owasp-crs-v030001-id941320-xss', 'owasp-crs-v030001-id941330-xss'])" #There's more to be added
         }
         rule_lfi = {
             action = "deny(403)"
             priority = "1002"
             expression = "evaluatePreconfiguredExpr('lfi-stable')"
         }
         rule_canary = {
             action = "deny(403)"
             priority = "1003"
             expression = "evaluatePreconfiguredExpr('rce-stable')"
         }
         rule_rfi = {
             action = "deny(403)"
             priority = "1004"
             expression = "evaluatePreconfiguredExpr('rfi-stable', ['owasp-crs-v030001-id931130-rfi'])"
         }
         rule_methodenforcement = {
             action = "deny(403)"
             priority = "1005"
             expression = "evaluatePreconfiguredExpr('methodenforcement-stable')"
         }
         rule_scandetection = {
             action = "deny(403)"
             priority = "1006"
             expression = "evaluatePreconfiguredExpr('scandetection-stable', ['owasp-crs-v030001-id913101-scandetection', 'owasp-crs-v030001-id913102-scandetection'])"
         }
         rule_protocolattach = {
             action = "deny(403)"
             priority = "1007"
             expression = "evaluatePreconfiguredExpr('protocolattack-stable', ['owasp-crs-v030001-id921151-protocolattack', 'owasp-crs-v030001-id921170-protocolattack'])"
         }
         rule_sessionfixation = {
             action = "deny(403)"
             priority = "1009"
             expression = "evaluatePreconfiguredExpr('sessionfixation-stable')"
         }
     }
     type = map(object({
         action         = string
         priority       = string
         expression     = string
     }))
 }
    
resource "google_compute_security_policy" "cloud-armor-security-policy" {
    project = var.project_id
    name = "cloud-armor-waf-policy"
    
    dynamic "rule" {
        for_each = var.default_rules
        content {
            action = rule.value.action
            priority = rule.value.priority
            description = rule.value.description
            match {
                versioned_expr = rule.value.versioned_expr
                config {
                    src_ip_ranges = rule.value.src_ip_ranges
                }
            }
        }
    }

     dynamic "rule" {
         for_each = var.owasp_rules
         content {
             action = rule.value.action
             priority = rule.value.priority
             match {
                 expr {
                     expression = rule.value.expression
                 }
             }
         }
     }
}

