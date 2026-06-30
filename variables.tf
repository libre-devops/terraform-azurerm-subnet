variable "nsg_associations" {
  description = "Map of subnet name to network security group id to associate. Keys are subnet names (must exist in subnets); values may be computed in the same apply (the static keys keep for_each valid)."
  type        = map(string)
  default     = {}
}

variable "route_table_associations" {
  description = "Map of subnet name to route table id to associate. Keys are subnet names (must exist in subnets); values may be computed in the same apply."
  type        = map(string)
  default     = {}
}

variable "subnet_delegation_actions" {
  description = "Lookup of subnet delegation service name to its delegated actions. A subnet's delegations reference these by service name; a service not listed here falls back to the platform-inferred actions."
  type        = map(list(string))
  default = {
    "GitHub.Network/networkSettings"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ApiManagement/service"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.App/environments"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.App/testClients"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Apollo/npu"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.AVS/PrivateClouds"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.AzureCosmosDB/clusters"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureHPC"           = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureHostedService" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzurePaymentHSM"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.BareMetal/AzureVMware" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.BareMetal/CrayServers" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.BareMetal/MonitoringServers"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Batch/batchAccounts"               = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/hostedpools"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/images"                  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.CloudTest/pools"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Codespaces/plans"                  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerInstance/containerGroups" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerService/managedClusters"  = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ContainerService/TestClients"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Databricks/workspaces" = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
    "Microsoft.DBforMySQL/flexibleServers"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforMySQL/servers"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforMySQL/serversv2"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforPostgreSQL/flexibleServers" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DBforPostgreSQL/serversv2"       = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.DBforPostgreSQL/singleServers"   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DelegatedNetwork/controller"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DevCenter/networkConnection"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.DevOpsInfrastructure/pools"      = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.DocumentDB/cassandraClusters"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Fidalgo/networkSettings"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.HardwareSecurityModules/dedicatedHSMs" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.Kusto/clusters"                       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.LabServices/labplans"                 = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Logic/integrationServiceEnvironments" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.MachineLearningServices/workspaces"   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Netapp/volumes" = [
      "Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"
    ]
    "Microsoft.Network/dnsResolvers"                 = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.Network/fpgaNetworkInterfaces"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/managedResolvers"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/networkWatchers"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Network/virtualNetworkGateways"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Orbital/orbitalGateways"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.PowerPlatform/enterprisePolicies"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.PowerPlatform/vnetaccesslinks"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ServiceFabricMesh/networks"           = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.ServiceNetworking/trafficControllers" = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Singularity/accounts/networks"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Singularity/accounts/npu"             = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstances" = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
    ]
    "Microsoft.Sql/managedInstancesOnebox"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstancesStage"     = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/managedInstancesTest"      = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Sql/servers"                   = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.StoragePool/diskPools"         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.StreamAnalytics/streamingJobs" = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    "Microsoft.Synapse/workspaces"            = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Web/hostingEnvironments"       = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Microsoft.Web/serverFarms"               = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "NGINX.NGINXPLUS/nginxDeployments"        = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "PaloAltoNetworks.Cloudngfw/firewalls"    = ["Microsoft.Network/virtualNetworks/subnets/action"]
    "Qumulo.Storage/fileSystems"              = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
}

variable "subnets" {
  description = <<-EOT
    Subnets to create in the virtual network, keyed by subnet name. Each subnet sets its address
    prefixes (or ip_address_pool) and optional service endpoints, delegations (service names only;
    the actions are looked up from subnet_delegation_actions), and policy flags. NSG and route table
    associations are separate inputs (nsg_associations / route_table_associations) so their ids may be
    computed in the same apply.

    Secure defaults: private_endpoint_network_policies defaults to "Enabled" (enforces NSG and route
    table rules on private endpoints), and default_outbound_access_enabled defaults to false (no
    implicit outbound internet; Azure is retiring default outbound, so attach an explicit egress such
    as the nat-gateway module). Both are overridable per subnet.
  EOT
  type = map(object({
    address_prefixes                              = optional(list(string), [])
    ip_address_pool                               = optional(object({ id = string, number_of_ip_addresses = string }), null)
    service_endpoints                             = optional(list(string), [])
    service_endpoint_policy_ids                   = optional(list(string), [])
    delegations                                   = optional(list(string), [])
    private_endpoint_network_policies             = optional(string, "Enabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    default_outbound_access_enabled               = optional(bool, false)
    sharing_scope                                 = optional(string, null)
  }))
  default = {}

  validation {
    condition     = alltrue([for name in keys(var.subnets) : length(name) >= 1 && length(name) <= 80])
    error_message = "Each subnet name must be 1 to 80 characters (the Azure subnet name limit)."
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : (length(s.address_prefixes) > 0) != (s.ip_address_pool != null)])
    error_message = "Each subnet must set exactly one of address_prefixes or ip_address_pool."
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], s.private_endpoint_network_policies)])
    error_message = "subnets[*].private_endpoint_network_policies must be Disabled, Enabled, NetworkSecurityGroupEnabled, or RouteTableEnabled."
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : s.sharing_scope == null || s.sharing_scope == "Tenant"])
    error_message = "subnets[*].sharing_scope must be null or \"Tenant\"."
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : s.sharing_scope == null || s.default_outbound_access_enabled == false])
    error_message = "subnets[*].sharing_scope can only be set when default_outbound_access_enabled is false."
  }
}

variable "virtual_network_id" {
  description = "Resource id of the existing virtual network to add subnets to. The resource group name and virtual network name are parsed from it (pass the network module's vnet_id output)."
  type        = string

  validation {
    condition     = try(provider::azurerm::parse_resource_id(var.virtual_network_id).resource_type, "") == "virtualNetworks"
    error_message = "virtual_network_id must be a virtual network id of the form /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<name>."
  }
}
