# Plan-time tests for the module. The azurerm provider is mocked, so no credentials, no
# features block, and no cloud calls are needed:
#   terraform init -backend=false && terraform test

mock_provider "azurerm" {}

variables {
  virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ldo-uks-tst-001/providers/Microsoft.Network/virtualNetworks/vnet-ldo-uks-tst-001"
  subnets = {
    "snet-app-vnet-ldo-uks-tst-001" = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

run "creates_subnet_in_the_parsed_vnet" {
  command = plan

  assert {
    condition     = length(azurerm_subnet.this) == length(var.subnets)
    error_message = "One subnet should be created per entry."
  }

  assert {
    condition     = output.resource_group_name == "rg-ldo-uks-tst-001" && output.virtual_network_name == "vnet-ldo-uks-tst-001"
    error_message = "The resource group and virtual network names should be parsed from virtual_network_id."
  }
}

run "subnet_secure_defaults" {
  command = plan

  assert {
    condition     = azurerm_subnet.this["snet-app-vnet-ldo-uks-tst-001"].private_endpoint_network_policies == "Enabled" && azurerm_subnet.this["snet-app-vnet-ldo-uks-tst-001"].default_outbound_access_enabled == false
    error_message = "Secure subnet defaults should match the network module (Enabled, false)."
  }
}

run "associations_created_from_maps" {
  command = plan

  variables {
    nsg_associations = {
      "snet-app-vnet-ldo-uks-tst-001" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/networkSecurityGroups/nsg-app"
    }
    route_table_associations = {
      "snet-app-vnet-ldo-uks-tst-001" = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/routeTables/rt-app"
    }
  }

  assert {
    condition     = length(azurerm_subnet_network_security_group_association.this) == 1 && length(azurerm_subnet_route_table_association.this) == 1
    error_message = "Associations should be created from the association maps."
  }
}

run "exposes_subnet_ids_zipmap" {
  command = plan

  assert {
    condition     = output.subnet_ids_zipmap["snet-app-vnet-ldo-uks-tst-001"].name == "snet-app-vnet-ldo-uks-tst-001"
    error_message = "subnet_ids_zipmap should map each subnet name to a { name, id } object."
  }
}

run "rejects_a_non_vnet_id" {
  command = plan

  variables {
    virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/sa"
  }

  expect_failures = [var.virtual_network_id]
}
