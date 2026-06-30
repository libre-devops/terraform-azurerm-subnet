# check blocks run after every plan and apply and emit a warning (without blocking) when an
# invariant is violated. They are the place to enforce module-wide consistency.

check "all_subnets_created" {
  assert {
    condition     = length(azurerm_subnet.this) == length(var.subnets)
    error_message = "Fewer subnets were created than requested; check for duplicate subnet names in var.subnets."
  }
}

check "associations_reference_known_subnets" {
  assert {
    condition = alltrue(concat(
      [for name in keys(var.nsg_associations) : contains(keys(var.subnets), name)],
      [for name in keys(var.route_table_associations) : contains(keys(var.subnets), name)],
    ))
    error_message = "nsg_associations / route_table_associations keys must be subnet names defined in var.subnets."
  }
}

check "subnet_delegations_are_known" {
  assert {
    condition = alltrue([
      for subnet in values(var.subnets) : alltrue([
        for delegation in subnet.delegations : contains(keys(var.subnet_delegation_actions), delegation)
      ])
    ])
    error_message = "A subnet delegation service name is not in subnet_delegation_actions; confirm the service name is correct (it will otherwise use platform-inferred actions)."
  }
}
