# Subnets added to an EXISTING virtual network. The vnet is passed by id; its resource group and name
# are parsed from it (per the pass-ids standard), so callers hand one id. NSG and route table
# associations are separate, subnet-name-keyed maps so their ids may be computed in the same apply.
# Route tables and NSGs are owned by their own modules; this one only associates them. The subnet
# schema and the delegation lookup mirror the network module so the two stay in lockstep.
locals {
  vnet                 = provider::azurerm::parse_resource_id(var.virtual_network_id)
  resource_group_name  = local.vnet.resource_group_name
  virtual_network_name = local.vnet.resource_name
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network_name

  name                                          = each.key
  address_prefixes                              = length(each.value.address_prefixes) > 0 ? each.value.address_prefixes : null
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  sharing_scope                                 = each.value.sharing_scope

  dynamic "ip_address_pool" {
    for_each = each.value.ip_address_pool != null ? [each.value.ip_address_pool] : []
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }

  dynamic "delegation" {
    for_each = each.value.delegations
    content {
      name = delegation.value
      service_delegation {
        name    = delegation.value
        actions = lookup(var.subnet_delegation_actions, delegation.value, null)
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.nsg_associations

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.route_table_associations

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value
}
