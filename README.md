# Azure VM Cost Control Policy

A custom Azure Policy that helps control Azure compute costs by restricting virtual machines to an approved list of VM SKUs.

## Policy Created

* `policies/enforce-vm-sku/policy-definition.json`

  * Denies Azure Virtual Machines using VM SKUs that are not included in the approved `allowedVmSkus` list.

Example:

```text
Standard_D2s_v5 → ALLOWED
Standard_D4s_v5 → ALLOWED
Other SKU       → DENIED
```

## How It Works

```text
VM Deployment
      ↓
 Azure Policy
      ↓
 Check VM SKU
   ↙       ↘
Allowed   Not Allowed
   ↓          ↓
 Allow       DENY
```

The policy uses the **Deny** effect to prevent unapproved VM deployments at deployment time.


## Project Structure

```text
azure-vm-cost-policy/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── policies/
│   └── enforce-vm-sku/
│       └── policy-definition.json
├── terraform/
│   └── main.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```

## Policy Parameter

The policy uses `allowedVmSkus` as an **Array parameter**.

The actual approved SKU values are provided when the policy is assigned, allowing the same policy definition to be reused across different scopes.

Example:

```json
{
  "allowedVmSkus": {
    "value": [
      "Standard_D2s_v5",
      "Standard_D4s_v5"
    ]
  }
}
```


## Design Decision

The policy definition and policy assignment are intentionally separated.

The **policy definition** contains the reusable governance rule, while the **policy assignment** determines where the policy is enforced and which VM SKUs are approved for that scope.

Keeping these separate allows the same policy definition to be reused at a management group, subscription, or resource group scope depending on the organization's governance requirements.

For example, different subscriptions or environments can use different approved VM SKU lists without creating separate policy definitions.


## Azure Login

Before running Terraform, authenticate to Azure using the Azure CLI and verify the active subscription:

```text
az login
az account show
```

## Terraform

Terraform is used to create the custom Azure Policy definition.

This repository creates **only the custom Azure Policy definition**.

Policy assignments and Azure workloads are managed separately based on the target environment.

Run the following commands from the repository root:

```bash
terraform -chdir=terraform init
terraform -chdir=terraform plan
terraform -chdir=terraform apply
```
Alternatively, navigate into the Terraform folder first:

```bash
cd terraform

terraform init
terraform plan
terraform apply
```

## GitHub Actions

GitHub Actions validates the Terraform configuration on every push and pull request. Recommended to perform before push.

CI performs:

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
```

These checks ensure that the Terraform configuration is properly formatted, can be initialized, and passes Terraform validation.



## Deployment Status

The custom policy definition has been successfully deployed to Azure using Terraform and verified through Azure CLI.

The policy is currently **not assigned**, so it does not enforce restrictions on existing Azure resources.
