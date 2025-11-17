# Simple Single-Stage Pipeline Automation

## Overview

This module covers the implementation of automated Infrastructure as Code deployment pipelines using GitHub Actions. You'll learn to create YAML pipelines that automatically deploy Terraform configurations and establish proper security and governance practices for production deployments.

## Learning Objectives

- Build GitHub Actions workflows for Terraform deployment
- Establish state management and locking for team collaboration
- Implement automated testing and validation in pipelines
- Troubleshoot common pipeline issues and deployment failures

---

## Test the Azure↔GitHub Connection

We will setup a very simple workflow to test the connection between GitHub and Azure.

The Workflow will simply connect to Azure, prepare terraform and plan the deployment of our resources.

Create a new folder structure in your repository named `.github/workflows/`:

```bash
mkdir -p .github/workflows
```

Create the following YAML file in `.github/workflows/terraform-ci-cd.yml`:

```yaml
name: 'Terraform CI/CD'

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  id-token: write   # Required for OIDC
  contents: read    # Required for checkout

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v5

    - name: Azure Login using OIDC
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      # with:
      #   terraform_version: 1.5.0    # It is recommended to pin to a specific version for production

    - name: Terraform Init
      run: terraform init
      working-directory: ./terraform

    - name: Terraform Plan
      run: terraform plan -var-file="environments/dev/terraform.tfvars"
      working-directory: ./terraform
```

Once created, commit and push the changes to your repository.

In GitHub, go to the "Actions" tab of your repository and select the "Terraform CI/CD" workflow. You should see the workflow running.

If the workflow completes successfully, it means that the connection between GitHub and Azure is working correctly, and Terraform has been initialized and planned successfully.

## Backend configuration

The current workflow does not use any backend configuration for Terraform state management. This means that the state file is stored locally on the runner, which is not suitable for team collaboration or production environments.

We will now update the workflow to use an Azure Storage Account as a backend for Terraform state management.

### Configure the workflow

Edit the workflow file `.github/workflows/terraform-ci-cd.yml` to update the `Terraform Init` step to include backend configuration:

```yaml
    # ...
    # Initialize a backend store for state management
    - name: Terraform Init with backend
      run: |
        terraform init \
          -backend-config="storage_account_name=tfstates${{ vars.RANDOM_SUFFIX }}" \
          -backend-config="container_name=iac-workshop-tfstates" \
          -backend-config="key=terraform-dev.tfstate" \
          -backend-config="resource_group_name=rg-terraform-state"
      working-directory: ./terraform
    # ...
```

### Configure backend for state management

Edit `terraform/versions.tf` to add the backend configuration in the `terraform` block:

```
  backend "azurerm" {
    use_azuread_auth = true
  }
```

Refer to HashiCorp documentation for more details: [Configure the AzureRM backend for Terraform](https://developer.hashicorp.com/terraform/language/backend/azurerm).


## Deployment Pipeline

Add few more steps to the workflow to validate, plan and  the baseline of the infrastructure.

```yaml
# .github/workflows/terraform-ci-cd.yml
name: 'Terraform CI/CD'

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  id-token: write   # Required for OIDC
  contents: read    # Required for checkout

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v5

    - name: Azure Login using OIDC
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      # with:
      #   terraform_version: 1.5.0    # It is recommended to pin to a specific version for production

    # Initialize a backend store for state management
    - name: Terraform Init with backend
      run: |
        terraform init \
          -backend-config="storage_account_name=tfstates${{ vars.RANDOM_SUFFIX }}" \
          -backend-config="container_name=iac-workshop-tfstates" \
          -backend-config="key=terraform-dev.tfstate" \
          -backend-config="resource_group_name=rg-terraform-state"
      working-directory: ./terraform

    - name: Terraform Validate
      run: terraform validate
      working-directory: ./terraform

    - name: Terraform Plan
      run: terraform plan -var-file="environments/dev/terraform.tfvars"
      working-directory: ./terraform

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push' # Only apply on push to main branch
      run: terraform apply -auto-approve -var-file="environments/dev/terraform.tfvars"
      working-directory: ./terraform
```

!!! info "If you did copy your terraform files from previous workshop"

    Change the Azure Keyvault network ACL to authorize access from all networks (for the purpose of this workshop only): `Allow` instead of `Deny`.

    ```hcl
      network_acls {
        default_action = "Allow"
        bypass         = "AzureServices"
        ip_rules       = [] # Add your IP addresses as needed
      }
    ```

    This configuration is not recommended for production environments but as we are using GitHub hosted runners with dynamic IP addresses, we cannot whitelist specific IPs.


Commit and push the changes to your repository. Observe the workflow running in the "*Actions*" tab of your repository.

!!! tip "My pipeline failed"

    If your pipeline fails, check the logs for errors. Common issues include:

    - Incorrect service connection permissions or naming
    - Missing backend storage account or container
    - Syntax errors in the YAML file

---

**Congratulations!** You have successfully set up a first simple single-stage CI/CD pipeline to validate, plan and apply Terraform configurations.

**Next Lab**: [Lab 3: Multi-Environment Pipeline Automation](03-multienv-pipeline.md)
