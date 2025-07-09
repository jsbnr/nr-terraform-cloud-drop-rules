variable dropRules { } # provided via config,tfvars

locals {
  level = "minimum" # which level rule to use from the following:
      #  minimum - drop INFO and DEBUG, ERROR - CRITICAL is kept
      #  medium - drop INFO  and DEBUG only
      #  high - drop INFO only
      #  maximum - drop nothing

  # determine which rules to use based on level
  level_rules = {
    "maximum" = []
    "high"    = var.dropRules.high
    "medium"  = concat(var.dropRules.high, var.dropRules.medium)
    "minimum" = concat(var.dropRules.high, var.dropRules.medium, var.dropRules.minimum)
  }
  selected_rules = lookup(local.level_rules, local.level, [])

}

module "drop_rules" {
  for_each = { for idx, rule in local.selected_rules : "drop_rule_${idx}" => rule }
  source      = "./modules/drop_rule"
  account_id  = each.value.account_id
  name        = each.value.name
  description = each.value.description
  action      = lookup(each.value, "action","")
  nrql        = lookup(each.value, "nrql", "")
  nrqlCloud   = lookup(each.value, "nrqlCloud", "")
  event_type  = lookup(each.value, "event_type", "")
  filter      = lookup(each.value, "filter", "")
  attributes  = lookup(each.value, "attributes", [])
}