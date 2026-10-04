# Azure VM Cost Control Policy

A simple Azure cost-control solution using **Azure Policy + Terraform + GitHub Actions**.

## What does it do?

The policy prevents users from deploying Azure Virtual Machines with VM SKUs that are not on the organization's approved list.

Example:

```text
Standard_D2s_v5  → ALLOWED
Standard_D4s_v5  → ALLOWED
Other SKU        → DENIED
```

This helps prevent unnecessary compute costs at deployment time.

## How it works

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

The policy uses the **Deny** effect because the goal is to prevent unapproved VM deployments rather than identify them after deployment.

## Project Structure

```text
azure-vm-cost-policy/
├── policy.json
├── main.tf
├── variables.tf
├── .gitignore
├── .terraform.lock.hcl
├── README.md
└── .github/
    └── workflows/
        └── terraform.yml
```

| File            | Purpose                                    |
| --------------- | ------------------------------------------ |
| `policy.json`   | Azure Policy rule                          |
| `main.tf`       | Terraform policy definition and assignment |
| `variables.tf`  | Configurable values and approved VM SKUs   |
| `terraform.yml` | GitHub Actions CI validation               |

## Tools

* Azure Policy
* Terraform
* GitHub
* GitHub Actions
* Visual Studio Code

## Development Flow

```text
Define Policy
     ↓
Write Terraform Configuration
     ↓
terraform fmt
     ↓
terraform validate
     ↓
Git Commit
     ↓
GitHub Actions
     ↓
Terraform Validation ✓
```

The policy is assigned to a **dedicated demo resource group** so testing is isolated from other resources.

## Deployment

With an authenticated Azure subscription:

```bash
terraform init
terraform plan
terraform apply
```

After deployment, the policy can be tested with an approved and an unapproved VM SKU.

## Current Limitation

This project was developed without an active Azure subscription.

Therefore, the Terraform configuration was validated locally and through GitHub Actions, but the policy was **not deployed to Azure during development**.

The deployment configuration is ready for an authenticated Azure environment.
