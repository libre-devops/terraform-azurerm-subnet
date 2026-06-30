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
