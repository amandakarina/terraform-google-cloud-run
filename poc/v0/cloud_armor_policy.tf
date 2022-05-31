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

}


