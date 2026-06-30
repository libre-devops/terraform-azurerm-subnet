output "resource_group_name" {
  description = "Resource group name parsed from virtual_network_id."
  value       = local.resource_group_name
}

output "subnet_address_prefixes" {
  description = "Map of subnet name to its address prefixes."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.address_prefixes }
}

output "subnet_ids" {
  description = "Map of subnet name to its id."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

output "subnet_ids_zipmap" {
  description = "Map of subnet name to a { name, id } object, for handing the whole object downstream."
  value       = { for name, subnet in azurerm_subnet.this : name => { name = subnet.name, id = subnet.id } }
}

output "subnet_names" {
  description = "The subnet names."
  value       = keys(azurerm_subnet.this)
}

output "subnet_nsg_association_ids" {
  description = "Map of subnet name to its network security group association id."
  value       = { for name, assoc in azurerm_subnet_network_security_group_association.this : name => assoc.id }
}

output "subnet_route_table_association_ids" {
  description = "Map of subnet name to its route table association id."
  value       = { for name, assoc in azurerm_subnet_route_table_association.this : name => assoc.id }
}

output "subnets" {
  description = "The full azurerm_subnet resources, keyed by subnet name."
  value       = azurerm_subnet.this
}

output "subscription_id" {
  description = "Subscription id parsed from virtual_network_id."
  value       = local.vnet.subscription_id
}

output "virtual_network_name" {
  description = "Virtual network name parsed from virtual_network_id."
  value       = local.virtual_network_name
}
