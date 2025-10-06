# Lab 1: Environment Setup & Validation

## Lab Overview

This hands-on lab guides you through setting up a complete Infrastructure as Code development environment and validating that all tools are properly configured for Terraform and Azure development.

## Lab Objectives

- Install and configure all required development tools
- Authenticate with Azure and verify access
- Set up VS Code with essential extensions
- Create a test Terraform configuration
- Validate the complete development workflow

!!! note "Bash"

    All command examples are provided in Bash syntax. Windows users can use Git Bash, WSL, or adapt commands for PowerShell.

## Prerequisites

- Administrative access to your computer
- Active Azure subscription
- Internet connectivity for tool downloads

---

## Part 1: Tool Installation and Configuration

### Step 1: Git Installation and Configuration

**Windows Installation**:

```powershell
# Option 1: Download and install from git-scm.com
# Option 2: Use Chocolatey
choco install git

# Verify installation
git --version
```

**macOS Installation**:

```bash
# Option 1: Use Homebrew
brew install git

# Option 2: Download from git-scm.com
# Verify installation
git --version
```

**Linux Installation**:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git

# CentOS/RHEL
sudo yum install git

# Verify installation
git --version
```

**Git Configuration**:

```bash
# Configure user identity (required)
git config --global user.name "Your Full Name"
git config --global user.email "your.email@company.com"

# Configure line endings
# Windows:
git config --global core.autocrlf true

# macOS/Linux:
git config --global core.autocrlf input

# Set default branch name
git config --global init.defaultBranch main

# Configure credential helper
git config --global credential.helper cache

# Verify configuration
git config --list
```

### Step 2: Visual Studio Code Setup

**Installation**:

1. Download VS Code from https://code.visualstudio.com/download
2. Install with default options
3. Launch VS Code

**Essential Extensions Installation**:

```bash
# Install extensions via command line
code --install-extension HashiCorp.terraform
code --install-extension ms-vscode.azurecli
code --install-extension ms-azure-devops.azure-pipelines
code --install-extension redhat.vscode-yaml
code --install-extension eamodio.gitlens
code --install-extension ms-vscode.azure-account

# Verify extensions are installed
code --list-extensions
```

**VS Code Configuration**:

Create/update VS Code settings:

```json
// File: settings.json (Ctrl+Shift+P -> "Preferences: Open Settings (JSON)")
{
  "terraform.experimentalFeatures.validateOnSave": true,
  "terraform.languageServer": {
    "external": true,
    "args": ["serve"]
  },
  "files.associations": {
    "*.tf": "terraform",
    "*.tfvars": "terraform"
  },
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "files.exclude": {
    "**/.terraform": true,
    "**/terraform.tfstate": true,
    "**/terraform.tfstate.backup": true
  }
}
```

### Step 3: Azure CLI Installation

**Windows Installation**:

```powershell
# Option 1: MSI Installer from Microsoft Learn
# Download and run: https://aka.ms/installazurecliwindows

# Option 2: PowerShell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Option 3: Chocolatey
choco install azure-cli
```

**macOS Installation**:
```bash
# Using Homebrew (recommended)
brew install azure-cli

# Alternative: Direct download
curl -L https://aka.ms/InstallAzureCli | bash
```

**Linux Installation**:

```bash
# Ubuntu/Debian
curl -sL https://aka.ms/InstallAzureCLIUbuntu | sudo bash

# CentOS/RHEL
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
sudo yum install azure-cli
```

**Verify Azure CLI Installation**:

```bash
# Check version (should be 2.30.0 or later)
az --version

# Login to Azure
az login

# List available subscriptions
az account list --output table

# Set default subscription (if you have multiple)
az account set --subscription "Your Subscription Name"

# Verify current context
az account show
```

### Step 4: Terraform Installation

!!! tip "Terraform or OpenTofu ?"

    This workshop uses Terraform by HashiCorp. OpenTofu is a community-driven fork of Terraform. While similar, there may be differences in features and support. You can choose to use OpenTofu in place of the Terraform commands and configurations provided here, but be aware of potential discrepancies.

**Windows Installation**:

```powershell
# Option 1: Chocolatey (recommended)
choco install terraform

# Option 2: Manual download
# Download from https://developer.hashicorp.com/terraform/downloads
# Extract to a directory in your PATH

# Verify installation
terraform version
```

**macOS Installation**:

```bash
# Option 1: Homebrew (recommended)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Option 2: Manual download
# Download from https://developer.hashicorp.com/terraform/downloads

# Verify installation
terraform version
```

**Linux Installation**:

```bash
# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# CentOS/RHEL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# Verify installation
terraform version
```

---

## Part 2: Workspace Setup

### Step 1: Create Project Directory Structure

```bash
# Create workshop directory
mkdir terraform-workshop
cd terraform-workshop

# Create directory structure
mkdir -p {terraform,scripts,docs}
mkdir -p terraform/environments/{dev,staging,prod}
mkdir -p terraform/modules

# Create initial files
touch terraform/main.tf
touch terraform/variables.tf
touch terraform/outputs.tf
touch terraform/versions.tf
touch .gitignore
touch README.md

# Verify structure
tree .
# or on Windows:
# dir /s
```

### Step 2: Git Repository Initialization

```bash
# Initialize Git repository
git init
```

Populate `.gitignore` file:

```gitignore
# Terraform files
**/.terraform/*
*.tfstate
*.tfstate.*
crash.log
*.tfvars
!*.tfvars.example
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

# Add files to Git

```bash
git add .
git commit -m "Initial project structure"
```

### Step 3: Terraform Configuration Files

**Create versions.tf**:

```terraform
# terraform/versions.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
```

**Create variables.tf**:

```terraform
# terraform/variables.tf
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraformworkshop"

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters and numbers."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "TerraformWorkshop"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

**Create main.tf**:

```terraform
# terraform/main.tf

# Generate unique suffix for globally unique resources
resource "random_id" "unique" {
  byte_length = 4
}

# Local values for consistent naming
locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  unique_suffix   = random_id.unique.hex

  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    CreatedDate = timestamp()
  })
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_prefix}"
  location = var.location

  tags = local.common_tags
}

# Storage Account for testing
resource "azurerm_storage_account" "main" {
  name                     = "st${replace(local.resource_prefix, "-", "")}${local.unique_suffix}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier            = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"

  # Security settings
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = var.environment == "prod" ? 30 : 7
    }
  }

  tags = local.common_tags
}
```

**Create outputs.tf**:

```terraform
# terraform/outputs.tf
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "unique_suffix" {
  description = "Unique suffix used for resource naming"
  value       = local.unique_suffix
}
```

**Create terraform.tfvars.example**:

```terraform
# terraform/terraform.tfvars.example
project_name = "workshop"
environment  = "dev"
location     = "East US"

tags = {
  Project     = "TerraformWorkshop"
  Environment = "dev"
  Owner       = "your-name"
  ManagedBy   = "Terraform"
}
```

---

## Part 3: Environment Validation

### Step 1: Initial Terraform Validation

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Validate configuration syntax
terraform validate

# Format code consistently
terraform fmt

# Check formatting (should show no changes)
terraform fmt -check
```

**Expected Output**:

```bash
❯ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 4.0"...
- Finding hashicorp/random versions matching "~> 3.1"...
- Installing hashicorp/azurerm v4.x.x...
- Installing hashicorp/random v3.x.x...

Terraform has been successfully initialized!

❯ terraform validate
Success! The configuration is valid.

❯ terraform fmt
main.tf

❯ terraform fmt -check
# empty
```

### Step 2: Create Variable File and Plan

```bash
# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit the file with your specific values
# Update project_name, environment, and tags as needed

# Create execution plan
terraform plan -out=tfplan

# Review the plan output carefully
```

**Expected Plan Output**:

```
Terraform will perform the following actions:

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "East US"
      + name     = "rg-workshop-dev"
      + tags     = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Project"     = "workshop"
        }
    }

  # azurerm_storage_account.main will be created
  + resource "azurerm_storage_account" "main" {
      + access_tier              = (known after apply)
      + account_kind            = "StorageV2"
      + account_replication_type = "LRS"
      + account_tier            = "Standard"
      + name                    = (known after apply)
      + location                = "East US"
      + resource_group_name     = "rg-workshop-dev"
      # ... additional attributes
    }

  # random_id.unique will be created
  + resource "random_id" "unique" {
      + byte_length = 4
      + hex         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

### Step 3: Deploy Infrastructure

```bash
# Apply the configuration
terraform apply tfplan

# Review outputs
terraform output

# View sensitive outputs
terraform output -raw storage_account_primary_access_key
```

**Expected Apply Output**:

```
random_id.unique: Creating...
random_id.unique: Creation complete after 0s [id=xxxxx]
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 2s [id=/subscriptions/.../resourceGroups/rg-workshop-dev]
azurerm_storage_account.main: Creating...
azurerm_storage_account.main: Still creating... [10s elapsed]
azurerm_storage_account.main: Creation complete after 23s [id=/subscriptions/.../storageAccounts/stworkshopdevxxxxx]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

resource_group_location = "East US"
resource_group_name = "rg-workshop-dev"
storage_account_name = "stworkshopdevxxxxx"
unique_suffix = "xxxxx"
```

### Step 4: Verify Resources in Azure

```bash
# Verify resource group creation
az group show --name "rg-workshop-dev" --output table

# List resources in the resource group
az resource list --resource-group "rg-workshop-dev" --output table

# Get storage account details
az storage account show --name "$(terraform output -raw storage_account_name)" --resource-group "$(terraform output -raw resource_group_name)" --output table
```

---

## Part 4: VS Code Integration Testing

### Step 1: Open Project in VS Code

```bash
# Open project in VS Code
code .
```

### Step 2: Test Terraform Extension Features

1. **Syntax Highlighting**: Open `main.tf` - verify color syntax highlighting
2. **IntelliSense**: Type `azurerm_` - should show auto-completion options
3. **Format on Save**: Make a formatting change and save - should auto-format
4. **Validation**: Introduce a syntax error - should show red squiggly lines

### Step 3: Test Git Integration

1. **Make Changes**: Modify a file (add a comment)
2. **View Changes**: Check Source Control panel in VS Code
3. **Stage Changes**: Stage the file
4. **Commit**: Commit with a message
5. **View History**: Use GitLens to view commit history

---

## Part 5: Cleanup and Validation Checklist

### Step 1: Resource Cleanup

```bash
# Destroy created resources
terraform plan -destroy -out=destroy-plan
terraform apply destroy-plan

# Verify resources are deleted
az group show --name "rg-workshop-dev" --output table
# Should return an error that the group doesn't exist
```

### Step 2: Environment Validation Checklist

Complete this checklist to verify your environment:

#### ✅ Tool Installation Validation

- [ ] Git version 2.30.0 or later: `git --version`
- [ ] Azure CLI version 2.30.0 or later: `az --version`
- [ ] Terraform version 1.0.0 or later: `terraform version`
- [ ] VS Code latest version: `code --version`

#### ✅ Authentication Validation

- [ ] Azure CLI logged in: `az account show`
- [ ] Correct subscription selected: `az account list --output table`
- [ ] Service principal permissions verified (if applicable)

#### ✅ VS Code Extension Validation

- [ ] HashiCorp Terraform extension installed
- [ ] Azure CLI Tools extension installed
- [ ] YAML extension installed
- [ ] GitLens extension installed
- [ ] Azure Account extension installed

#### ✅ Terraform Workflow Validation

- [ ] `terraform init` runs successfully
- [ ] `terraform validate` passes
- [ ] `terraform fmt` works correctly
- [ ] `terraform plan` generates valid plan
- [ ] `terraform apply` deploys resources
- [ ] `terraform destroy` removes resources

#### ✅ Git Workflow Validation

- [ ] Git user configured: `git config user.name` and `git config user.email`
- [ ] Repository initialized successfully
- [ ] Files can be staged and committed
- [ ] .gitignore excludes proper files

### Step 3: Troubleshooting Common Issues

**Issue: Terraform Azure Provider Authentication Failed**

```bash
# Solution: Re-login to Azure CLI
az logout
az login
az account set --subscription "your-subscription-name"
```

**Issue: VS Code Extensions Not Working**

```bash
# Solution: Reload VS Code window
# Press Ctrl+Shift+P (or Cmd+Shift+P on macOS)
# Type: "Developer: Reload Window"
```

**Issue: Terraform State Locked**

```bash
# Solution: Force unlock (only if you're sure no other process is running)
terraform force-unlock <lock-id>
```

**Issue: Azure CLI Not Found**

```bash
# Solution: Add Azure CLI to PATH or reinstall
# Windows: Add installation directory to PATH
# macOS/Linux: Reinstall with package manager
```

---

## Lab Completion

### Success Criteria

You have successfully completed Lab 1 if you can:

1. ✅ Execute all Terraform commands without errors
2. ✅ Deploy and destroy Azure resources using Terraform
3. ✅ Use VS Code with proper syntax highlighting and IntelliSense
4. ✅ Authenticate with Azure CLI successfully
5. ✅ Commit and manage code with Git

### Next Steps

- **Save your configuration**: Keep the terraform-workshop directory for future labs
- **Document issues**: Note any issues encountered and solutions for future reference
- **Practice**: Try creating additional resources like virtual networks or web apps

---

**Congratulations!** You have successfully set up and validated your Infrastructure as Code development environment. You're now ready to proceed to Lab 2: Building Basic Terraform Configurations.

**Next Lab**: [Lab 2: Building Basic Terraform Configurations](02-terraform-fundamentals.md)

!!! abstract "Lab 2 Preview"

    In the next lab, you'll learn how to build and deploy a complete Azure infrastructure using Terraform, including resource groups, storage accounts, and networking components.
