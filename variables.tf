variable "location" {
  description = "Azure region for the policy resource group."
  type        = string
  default     = "Southeast Asia"
}

variable "resource_group_name" {
  description = "Resource group where the policy will be assigned."
  type        = string
  default     = "rg-vm-cost-policy-demo"
}

//IMPORTANT
variable "allowed_vm_skus" {
  description = "VM SKUs approved for deployment."
  type        = list(string)

  default = [
    "Standard_D2s_v5",
    "Standard_D4s_v5"
  ]
}