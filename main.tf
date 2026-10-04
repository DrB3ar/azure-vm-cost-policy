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

resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_policy_definition" "vm_cost_control" {
  name         = "vm-cost-control-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Azure VM Cost Control - Allowed SKUs"
  description  = "Restricts Azure virtual machines to approved VM SKUs to help control compute costs."

  policy_rule = file("${path.module}/policy.json")

  parameters = jsonencode({
    allowedVmSkus = {
      type = "Array"
      metadata = {
        displayName = "Allowed VM SKUs"
        description = "List of approved virtual machine SKUs."
      }
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "vm_cost_control" {
  name                 = "vm-cost-control-assignment"
  resource_group_id    = azurerm_resource_group.demo.id
  policy_definition_id = azurerm_policy_definition.vm_cost_control.id

  parameters = jsonencode({
    allowedVmSkus = {
      value = var.allowed_vm_skus
    }
  })
}