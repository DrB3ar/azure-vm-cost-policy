terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_policy_definition" "vm_cost_control" {
  name         = "vm-cost-control-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure VM Cost Control - Allowed SKUs"
  description  = "Restricts Azure virtual machines to approved VM SKUs to help control compute costs."

  policy_rule = file("${path.module}/../policies/enforce-vm-sku/policy-definition.json")

  parameters = jsonencode({
    allowedVmSkus = {
      type = "Array"

      metadata = {
        displayName = "Allowed VM SKUs"
        description = "List of VM SKUs approved by the organization."
      }
    }
  })
}