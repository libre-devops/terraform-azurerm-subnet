locals {
  location  = lookup(var.regions, var.loc, "uksouth")
  rg_name   = "rg-${var.short}-${var.loc}-${terraform.workspace}-001"
  vnet_name = "vnet-${var.short}-${var.loc}-${terraform.workspace}-001"
}

module "tags" {
  source  = "libre-devops/tags/azurerm"
  version = "~> 4.0"

  cost_centre     = "1888/67"
  owner           = "platform@example.com"
  deployed_branch = var.deployed_branch
  deployed_repo   = var.deployed_repo
}

module "rg" {
  source  = "libre-devops/rg/azurerm"
  version = "~> 4.0"

  resource_groups = [{ name = local.rg_name, location = local.location, tags = module.tags.tags }]
}

# An existing virtual network (no subnets of its own).
module "network" {
  source  = "libre-devops/network/azurerm"
  version = "~> 4.0"

  resource_group_id = module.rg.ids[local.rg_name]
  location          = local.location
  tags              = module.tags.tags

  vnet_name     = local.vnet_name
  address_space = ["10.50.0.0/24"]
}

# Calculate the subnet CIDRs, then add them to the existing vnet with this module.
module "subnet_calculator" {
  source  = "libre-devops/subnet-calculator/azurerm"
  version = "~> 4.0"

  base_cidr = "10.50.0.0/24"
  vnet_name = local.vnet_name

  subnets = [
    { purpose = "app", size = 26 },
    { purpose = "data", size = 27 },
  ]
}

# Raw NSG and route table to demonstrate the associations by id.
resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.short}-${var.loc}-${terraform.workspace}-001"
  resource_group_name = module.rg.names[local.rg_name]
  location            = local.location
  tags                = module.tags.tags
}

resource "azurerm_route_table" "this" {
  name                = "rt-${var.short}-${var.loc}-${terraform.workspace}-001"
  resource_group_name = module.rg.names[local.rg_name]
  location            = local.location
  tags                = module.tags.tags
}

module "subnet" {
  source = "../../"

  virtual_network_id = module.network.vnet_id

  # Take the calculator's address prefixes and layer the full per-subnet surface on top: service
  # endpoints, a delegation, and private-endpoint-policy / default-outbound overrides.
  subnets = {
    "snet-app-${local.vnet_name}" = merge(module.subnet_calculator.network_subnets["snet-app-${local.vnet_name}"], {
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.KeyVault"]
      private_link_service_network_policies_enabled = true
    })
    "snet-data-${local.vnet_name}" = merge(module.subnet_calculator.network_subnets["snet-data-${local.vnet_name}"], {
      delegations                       = ["Microsoft.Web/serverFarms"]
      private_endpoint_network_policies = "Disabled"
      default_outbound_access_enabled   = true
    })
  }

  nsg_associations = { for name, _ in module.subnet_calculator.network_subnets : name => azurerm_network_security_group.this.id }
  route_table_associations = {
    "snet-app-${local.vnet_name}" = azurerm_route_table.this.id
  }
}
