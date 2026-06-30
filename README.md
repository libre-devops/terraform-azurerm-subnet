<!--
  This is the template for every Libre DevOps Terraform module. When you create a module from it:
    - replace the title, tagline, and the CI workflow / repo name in the badge URLs
    - replace the resources in main.tf, and the variables, outputs, and examples to match
    - run `just docs` (or Sort-LdoTerraform.ps1) to regenerate the section between the markers
-->
<!--
  Keep the title and badges OUTSIDE the centered <div>: the Terraform Registry's markdown renderer
  does not parse markdown inside an HTML block, so a # heading or [![badge]] in the div renders as
  literal text on the registry. Only the logo (HTML) goes in the div.
-->
<div align="center">
  <a href="https://libredevops.org">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://libredevops.org/assets/libre-devops-white.png">
      <img alt="Libre DevOps" src="https://libredevops.org/assets/libre-devops-black.png" width="300">
    </picture>
  </a>
</div>

# Terraform Azure Subnet

Adds subnets to an **existing** Azure virtual network, with each subnet's optional NSG and route table
associations. The standalone companion to the network module: it shares the same subnet schema and
delegation lookup, for when subnets are owned by a different stack than the vnet.

[![CI](https://github.com/libre-devops/terraform-azurerm-subnet/actions/workflows/ci.yml/badge.svg)](https://github.com/libre-devops/terraform-azurerm-subnet/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/libre-devops/terraform-azurerm-subnet?sort=semver&label=release)](https://github.com/libre-devops/terraform-azurerm-subnet/releases/latest)
[![Terraform Registry](https://img.shields.io/badge/registry-libre--devops-7B42BC?logo=terraform&logoColor=white)](https://registry.terraform.io/namespaces/libre-devops)
[![License](https://img.shields.io/github/license/libre-devops/terraform-azurerm-subnet)](./LICENSE)

---

## Overview

The same subnet schema as the network module, but for an existing vnet: pass the `virtual_network_id`
(the resource group and vnet name are parsed from it), a map of subnets, and optional `nsg_associations`
/ `route_table_associations` (subnet-name-keyed maps, so ids may be computed in the same apply). Secure
subnet defaults match the network module (`private_endpoint_network_policies = "Enabled"`,
`default_outbound_access_enabled = false`). Pairs naturally with the subnet-calculator module, whose
`network_subnets` output drops straight in.

## Usage

```hcl
module "subnet" {
  source  = "libre-devops/subnet/azurerm"
  version = "~> 4.0"

  virtual_network_id = module.network.vnet_id

  subnets = {
    "snet-app-vnet-ldo-uks-prd-001" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      delegations       = ["Microsoft.Web/serverFarms"]
    }
  }

  nsg_associations = {
    "snet-app-vnet-ldo-uks-prd-001" = module.nsg.id
  }
}
```

## Examples

- [`examples/minimal`](./examples/minimal) - add one subnet to a vnet.
- [`examples/complete`](./examples/complete) - calculate subnets, then add them with NSG / route table
  associations.

## Developing

Local work needs **PowerShell 7+** and **[`just`](https://github.com/casey/just)**, because the recipes
wrap the [LibreDevOpsHelpers](https://www.powershellgallery.com/packages/LibreDevOpsHelpers)
PowerShell module (the same engine the `libre-devops/terraform-azure` action runs in CI). Install
just with `brew install just`, or `uv tool add rust-just` then `uv run just <recipe>`.

Run `just` to list recipes: `just update-ldo-pwsh` (install or force-update LibreDevOpsHelpers from
PSGallery), `just validate`, `just scan` (Trivy only), `just pwsh-analyze` (PSScriptAnalyzer only),
`just plan`, `just apply`, `just destroy`, `just e2e`, `just test`, and `just docs` (the
plan/apply/destroy recipes mirror the action, including the storage firewall dance; `just e2e`
applies an example then always destroys it, defaulting to `minimal`, so nothing is left running).
Releasing is also `just`:
`just increment-release [patch|minor|major]` bumps, tags, and publishes a GitHub release, and the
Terraform Registry picks up the tag.

## Security scan exceptions

This module is scanned with [Trivy](https://github.com/aquasecurity/trivy); HIGH and CRITICAL
findings fail the build. Any waiver is a deliberate, reviewed decision, never a way to quiet a
finding that should be fixed. Waivers live in [`.trivyignore.yaml`](./.trivyignore.yaml) (the
machine-applied source of truth, passed to Trivy with `--ignorefile`) and are mirrored in the table
below so the reason is auditable.

| Trivy ID | Resource | Finding | Justification |
|----------|----------|---------|---------------|
| _None_   |          |         |               |

To add an exception: add an entry to `.trivyignore.yaml` (`id`, optional `paths` to scope it, and a
`statement` recording why), then add a matching row here. Where the finding is out of this module's
scope, point the justification at the Libre DevOps module that does address it (for example the
private-endpoint module). Both the file and this table are reviewed in the pull request.

## Reference

The Requirements, Providers, Inputs, Outputs, and Resources below are generated by `terraform-docs`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0, < 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nsg_associations"></a> [nsg\_associations](#input\_nsg\_associations) | Map of subnet name to network security group id to associate. Keys are subnet names (must exist in subnets); values may be computed in the same apply (the static keys keep for\_each valid). | `map(string)` | `{}` | no |
| <a name="input_route_table_associations"></a> [route\_table\_associations](#input\_route\_table\_associations) | Map of subnet name to route table id to associate. Keys are subnet names (must exist in subnets); values may be computed in the same apply. | `map(string)` | `{}` | no |
| <a name="input_subnet_delegation_actions"></a> [subnet\_delegation\_actions](#input\_subnet\_delegation\_actions) | Lookup of subnet delegation service name to its delegated actions. A subnet's delegations reference these by service name; a service not listed here falls back to the platform-inferred actions. | `map(list(string))` | <pre>{<br/>  "GitHub.Network/networkSettings": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.AVS/PrivateClouds": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ApiManagement/service": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Apollo/npu": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.App/environments": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.App/testClients": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.AzureCosmosDB/clusters": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.BareMetal/AzureHPC": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.BareMetal/AzureHostedService": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.BareMetal/AzurePaymentHSM": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.BareMetal/AzureVMware": [<br/>    "Microsoft.Network/networkinterfaces/*",<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.BareMetal/CrayServers": [<br/>    "Microsoft.Network/networkinterfaces/*",<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.BareMetal/MonitoringServers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Batch/batchAccounts": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.CloudTest/hostedpools": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.CloudTest/images": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.CloudTest/pools": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Codespaces/plans": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ContainerInstance/containerGroups": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ContainerService/TestClients": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ContainerService/managedClusters": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DBforMySQL/flexibleServers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DBforMySQL/servers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DBforMySQL/serversv2": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DBforPostgreSQL/flexibleServers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DBforPostgreSQL/serversv2": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.DBforPostgreSQL/singleServers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Databricks/workspaces": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br/>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",<br/>    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"<br/>  ],<br/>  "Microsoft.DelegatedNetwork/controller": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DevCenter/networkConnection": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.DevOpsInfrastructure/pools": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.DocumentDB/cassandraClusters": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Fidalgo/networkSettings": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.HardwareSecurityModules/dedicatedHSMs": [<br/>    "Microsoft.Network/networkinterfaces/*",<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.Kusto/clusters": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.LabServices/labplans": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Logic/integrationServiceEnvironments": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.MachineLearningServices/workspaces": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Netapp/volumes": [<br/>    "Microsoft.Network/networkinterfaces/*",<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.Network/dnsResolvers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.Network/fpgaNetworkInterfaces": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Network/managedResolvers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Network/networkWatchers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Network/virtualNetworkGateways": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Orbital/orbitalGateways": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.PowerPlatform/enterprisePolicies": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.PowerPlatform/vnetaccesslinks": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ServiceFabricMesh/networks": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.ServiceNetworking/trafficControllers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Singularity/accounts/networks": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Singularity/accounts/npu": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Sql/managedInstances": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action",<br/>    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",<br/>    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"<br/>  ],<br/>  "Microsoft.Sql/managedInstancesOnebox": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Sql/managedInstancesStage": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Sql/managedInstancesTest": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Sql/servers": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.StoragePool/diskPools": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.StreamAnalytics/streamingJobs": [<br/>    "Microsoft.Network/virtualNetworks/subnets/join/action"<br/>  ],<br/>  "Microsoft.Synapse/workspaces": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Web/hostingEnvironments": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Microsoft.Web/serverFarms": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "NGINX.NGINXPLUS/nginxDeployments": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "PaloAltoNetworks.Cloudngfw/firewalls": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ],<br/>  "Qumulo.Storage/fileSystems": [<br/>    "Microsoft.Network/virtualNetworks/subnets/action"<br/>  ]<br/>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create in the virtual network, keyed by subnet name. Each subnet sets its address<br/>prefixes (or ip\_address\_pool) and optional service endpoints, delegations (service names only;<br/>the actions are looked up from subnet\_delegation\_actions), and policy flags. NSG and route table<br/>associations are separate inputs (nsg\_associations / route\_table\_associations) so their ids may be<br/>computed in the same apply.<br/><br/>Secure defaults: private\_endpoint\_network\_policies defaults to "Enabled" (enforces NSG and route<br/>table rules on private endpoints), and default\_outbound\_access\_enabled defaults to false (no<br/>implicit outbound internet; Azure is retiring default outbound, so attach an explicit egress such<br/>as the nat-gateway module). Both are overridable per subnet. | <pre>map(object({<br/>    address_prefixes                              = optional(list(string), [])<br/>    ip_address_pool                               = optional(object({ id = string, number_of_ip_addresses = string }), null)<br/>    service_endpoints                             = optional(list(string), [])<br/>    service_endpoint_policy_ids                   = optional(list(string), [])<br/>    delegations                                   = optional(list(string), [])<br/>    private_endpoint_network_policies             = optional(string, "Enabled")<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>    default_outbound_access_enabled               = optional(bool, false)<br/>    sharing_scope                                 = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | Resource id of the existing virtual network to add subnets to. The resource group name and virtual network name are parsed from it (pass the network module's vnet\_id output). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name parsed from virtual\_network\_id. |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Map of subnet name to its address prefixes. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet name to its id. |
| <a name="output_subnet_ids_zipmap"></a> [subnet\_ids\_zipmap](#output\_subnet\_ids\_zipmap) | Map of subnet name to a { name, id } object, for handing the whole object downstream. |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | The subnet names. |
| <a name="output_subnet_nsg_association_ids"></a> [subnet\_nsg\_association\_ids](#output\_subnet\_nsg\_association\_ids) | Map of subnet name to its network security group association id. |
| <a name="output_subnet_route_table_association_ids"></a> [subnet\_route\_table\_association\_ids](#output\_subnet\_route\_table\_association\_ids) | Map of subnet name to its route table association id. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The full azurerm\_subnet resources, keyed by subnet name. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Subscription id parsed from virtual\_network\_id. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | Virtual network name parsed from virtual\_network\_id. |
<!-- END_TF_DOCS -->
