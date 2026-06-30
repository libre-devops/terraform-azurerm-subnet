output "calculated_subnets" {
  description = "The calculator's per-subnet facts."
  value       = module.subnet_calculator.subnets
}

output "subnet_ids" {
  description = "Map of subnet name to id."
  value       = module.subnet.subnet_ids
}

output "subnet_nsg_association_ids" {
  description = "Map of subnet name to its NSG association id."
  value       = module.subnet.subnet_nsg_association_ids
}

output "tags" {
  description = "The tags applied to the resources."
  value       = module.tags.tags
}

output "vnet_id" {
  description = "The id of the virtual network the subnets were added to."
  value       = module.network.vnet_id
}
