output "subnet_ids" {
  description = "Map of subnet name to id."
  value       = module.subnet.subnet_ids
}

output "vnet_id" {
  description = "The id of the virtual network the subnets were added to."
  value       = module.network.vnet_id
}
