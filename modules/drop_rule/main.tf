
locals {

    # Legacy Rules
    constructed_legacy_nrql = var.event_type != "" ? "SELECT ${length(var.attributes) > 0 ? " ${join(", ", var.attributes)}" : " * "} FROM ${var.event_type} ${var.filter != "" ? " WHERE ${var.filter}" : ""}" : ""
    legacy_nrql = var.nrql != "" ? var.nrql : local.constructed_legacy_nrql
    legacy_action = var.action !="" ? var.action : length(var.attributes) > 0 ? "drop_attributes" : "drop_data"


    # Cloud rules
    # Construct nrqlCloud from constituent parts if not provided directly
    constructed_cloud_nrql = var.event_type != "" ? "DELETE ${length(var.attributes) > 0 ? " ${join(", ", var.attributes)}" : ""} FROM ${var.event_type} ${var.filter != "" ? " WHERE ${var.filter}" : ""}" : ""
    
    # Use provided nrqlCloud, or constructed query
    nrqlCloud = var.nrqlCloud != "" ? var.nrqlCloud : local.constructed_cloud_nrql
}


# Create rules using legacy provider

# resource "newrelic_nrql_drop_rule" "legacy_drop_rule" {
#   account_id  = var.account_id
#   description = var.description
#   action      = local.legacy_action
#   nrql        = local.legacy_nrql
# }


#Create rules using cloud control

resource "graphql_mutation" "cloud_drop_rule" {
  mutation_variables = {
    accountId = var.account_id,
    description = var.description,
    name  = var.name,
    nrql = local.nrqlCloud
  }
  compute_mutation_keys = {
    "id" = "entityManagementCreatePipelineCloudRule.entity.id"  
  }
  force_replace = true
  enable_remote_state_verification = false
  compute_from_create = true
  create_mutation = file("${path.module}/gql/createMutation.gql")
  update_mutation = file("${path.module}/gql/updateMutation.gql")
  delete_mutation = file("${path.module}/gql/deleteMutation.gql")
  read_query      = file("${path.module}/gql/readQuery.gql")
}

output "drop_rule_id" {
  value=graphql_mutation.cloud_drop_rule.computed_read_operation_variables.id
}