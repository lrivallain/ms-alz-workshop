# Environment Setup & Tool Configuration

## Overview
This module covers the essential development environment setup required for Infrastructure as Code development using Terraform and Azure. A properly configured environment is crucial for productivity and success in modern cloud infrastructure management.

## Learning Objectives
- Install and configure all required development tools
- Understand the purpose and role of each tool in the IaC workflow
- Validate tool installations and configurations
- Establish authentication and access to Azure resources
- Configure VS Code for optimal Terraform development

---

## Required Tools Deep Dive

### 1. Git - Version Control Foundation

**Purpose**: Git is the foundation of modern software development and Infrastructure as Code workflows. It provides version control, collaboration, and the basis for GitOps practices.

**Key Concepts**:
- **Repository**: Container for your infrastructure code and history
- **Commits**: Snapshots of your infrastructure changes
- **Branches**: Parallel development workflows
- **Remote**: Shared repository (GitHub, Azure Repos, GitLab)

**Installation & Configuration**:

```bash
# Verify installation
git --version

# Configure user identity
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# Configure line endings (Windows)
git config --global core.autocrlf true

# Configure line endings (macOS/Linux)
git config --global core.autocrlf input

# Set default branch name
git config --global init.defaultBranch main

# Configure credential caching
git config --global credential.helper cache
```

**VS Code Integration**:
- Built-in Git support with visual diff
- Source Control panel for staging and commits
- GitLens extension for enhanced Git capabilities

### 2. Visual Studio Code - Modern Development Environment

**Purpose**: VS Code is the recommended editor for Terraform development, offering excellent language support, debugging capabilities, and integrated terminal access.

**Essential Extensions for IaC**:

| Extension | Publisher | Purpose |
|-----------|-----------|---------|
| **HashiCorp Terraform** | HashiCorp | Syntax highlighting, IntelliSense, formatting |
| **Azure Terraform** | Microsoft | Azure-specific Terraform snippets and validation |
| **Azure CLI Tools** | Microsoft | Azure CLI command support and IntelliSense |
| **YAML** | Red Hat | YAML syntax support for Azure DevOps pipelines |
| **GitLens** | GitKraken | Enhanced Git capabilities and history visualization |
| **Azure Account** | Microsoft | Azure subscription and resource management |

**Configuration Recommendations**:

```json
// settings.json
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
  "editor.insertSpaces": true
}
```

**Workspace Configuration**:
```json
// .vscode/settings.json (workspace-specific)
{
  "terraform.experimentalFeatures.validateOnSave": true,
  "files.exclude": {
    "**/.terraform": true,
    "**/terraform.tfstate": true,
    "**/terraform.tfstate.backup": true
  }
}
```

### 3. Azure CLI - Azure Resource Management

**Purpose**: The Azure CLI is the primary command-line tool for Azure resource management, authentication, and automation. It's essential for Terraform Azure provider authentication.

**Core Functionality**:
- **Authentication**: Login and manage Azure credentials
- **Resource Management**: Create, update, delete Azure resources
- **Scripting**: Automate Azure operations
- **Configuration**: Set defaults and preferences

**Installation Validation**:
```bash
# Check version (should be 2.30.0 or later)
az --version

# Login to Azure
az login

# List available subscriptions
az account list --output table

# Set default subscription
az account set --subscription "Your Subscription Name"

# Verify current context
az account show
```

**Authentication Methods**:

1. **Interactive Login** (Development):
   ```bash
   az login
   ```

2. **Service Principal** (Production/CI):
   ```bash
   az login --service-principal \
     --username $ARM_CLIENT_ID \
     --password $ARM_CLIENT_SECRET \
     --tenant $ARM_TENANT_ID
   ```

3. **Managed Identity** (Azure VMs):
   ```bash
   az login --identity
   ```

**Common Azure CLI Commands for IaC**:
```bash
# Resource Groups
az group list --output table
az group create --name "rg-terraform-workshop" --location "eastus"

# Storage Accounts (for Terraform state)
az storage account create \
  --name "tfstatestorageunique" \
  --resource-group "rg-terraform-workshop" \
  --location "eastus" \
  --sku "Standard_LRS"

# Key Vault (for secrets)
az keyvault create \
  --name "kv-terraform-workshop" \
  --resource-group "rg-terraform-workshop" \
  --location "eastus"
```

### 4. Terraform - Infrastructure as Code Engine

**Purpose**: Terraform is the core tool for defining, planning, and deploying infrastructure. Understanding its installation and configuration is crucial for successful IaC implementation.

**Installation Methods**:

**Method 1: Direct Download**
```bash
# Download from releases page
# https://developer.hashicorp.com/terraform/downloads

# Verify installation
terraform version
```

**Method 2: Package Managers**
```bash
# Windows (Chocolatey)
choco install terraform

# macOS (Homebrew)
brew install terraform

# Linux (APT - Ubuntu/Debian)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

**Configuration and Environment Variables**:

```bash
# Environment variables for Azure provider (Bash/Linux/macOS)
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"

# For Windows PowerShell, use the following syntax:
# $env:ARM_SUBSCRIPTION_ID="your-subscription-id"
# $env:ARM_TENANT_ID="your-tenant-id"
# $env:ARM_CLIENT_ID="your-client-id"
# $env:ARM_CLIENT_SECRET="your-client-secret"

# Terraform-specific environment variables
export TF_LOG=INFO  # Enable detailed logging
export TF_LOG_PATH="./terraform.log"  # Log to file
export TF_DATA_DIR=".terraform"  # Data directory location
```

**Terraform Configuration Files**:

```bash
# Directory structure
project/
├── main.tf              # Main configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── terraform.tfvars    # Variable values
├── versions.tf         # Provider requirements
└── .terraform/         # Terraform working directory
```

**Essential Terraform Commands**:
```bash
# Initialize working directory
terraform init

# Validate configuration syntax
terraform validate

# Format code consistently
terraform fmt

# Plan infrastructure changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list
```

---

## Environment Validation Checklist

Use this checklist to verify your development environment is properly configured:

### ✅ Git Configuration
- [ ] Git version 2.30.0 or later
- [ ] User name and email configured
- [ ] Default branch set to 'main'
- [ ] Credential helper configured
- [ ] Line ending configuration appropriate for OS

**Validation Commands**:
```bash
git --version
git config --list | grep user
git config --list | grep core
```

### ✅ VS Code Setup
- [ ] VS Code latest version installed
- [ ] HashiCorp Terraform extension installed
- [ ] Azure Terraform extension installed
- [ ] Azure CLI Tools extension installed
- [ ] YAML extension installed
- [ ] GitLens extension installed
- [ ] Terraform language server configured

**Validation Commands**:
```bash
code --version
code --list-extensions | grep -E "(hashicorp|ms-azure|redhat|eamodio)"
```

### ✅ Azure CLI Authentication
- [ ] Azure CLI version 2.30.0 or later
- [ ] Successfully logged into Azure
- [ ] Correct subscription selected
- [ ] Contributor permissions verified
- [ ] Resource providers registered

**Validation Commands**:
```bash
az --version
az account show
az account list-locations --output table
az provider list --query "[?registrationState=='Registered'].namespace" --output table
```

### ✅ Terraform Installation
- [ ] Terraform version 1.0.0 or later
- [ ] Terraform binary in system PATH
- [ ] Azure provider authentication working
- [ ] Basic configuration validation passes

**Validation Commands**:
```bash
terraform version
terraform providers
```

**Test Configuration** (`test.tf`):
```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

output "current_user" {
  value = data.azurerm_client_config.current
}
```

**Test Commands**:
```bash
terraform init
terraform plan
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

---

## Common Environment Issues and Solutions

### Issue 1: Terraform Azure Provider Authentication

**Symptoms**:
```
Error: Error building AzureRM Client: obtain subscription() from Azure CLI: Azure CLI is not logged in
```

**Solutions**:
```bash
# Solution 1: Re-login to Azure CLI
az logout
az login

# Solution 2: Set explicit subscription
az account set --subscription "subscription-name-or-id"

# Solution 3: Use environment variables
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Issue 2: Terraform Lock File Conflicts

**Symptoms**:
```
Error: Error locking state: Error acquiring the state lock
```

**Solutions**:
```bash
# Check for existing locks
terraform force-unlock <lock-id>

# Ensure no other Terraform processes running
ps aux | grep terraform

# Check state file permissions
ls -la terraform.tfstate
```

### Issue 3: VS Code Terraform Extension Issues

**Symptoms**:
- No syntax highlighting
- No IntelliSense
- Format on save not working

**Solutions**:
```bash
# Reload VS Code window
Ctrl+Shift+P -> "Developer: Reload Window"

# Reinstall Terraform extension
code --uninstall-extension HashiCorp.terraform
code --install-extension HashiCorp.terraform

# Check workspace settings
cat .vscode/settings.json
```

### Issue 4: Git Line Ending Issues (Windows)

**Symptoms**:
```
warning: LF will be replaced by CRLF
```

**Solutions**:
```bash
# Configure Git for Windows
git config --global core.autocrlf true

# For specific repository
git config core.autocrlf true

# Check current setting
git config --list | grep autocrlf
```

---

## Development Workflow Best Practices

### 1. Directory Organization
```bash
# Recommended project structure
project-name/
├── .gitignore                 # Git ignore patterns
├── README.md                  # Project documentation
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── modules/
│   │   ├── networking/
│   │   ├── compute/
│   │   └── data/
│   └── shared/
└── scripts/
    ├── setup.sh
    └── deploy.sh
```

### 2. Git Ignore Configuration
```gitignore
# .gitignore for Terraform projects
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Exclude all .tfvars files, which are likely to contain sensitive data
*.tfvars

# Ignore override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you wish to add to version control
# !example_override.tf

# Include .tfvars.example files
*.tfvars.example

# Ignore CLI configuration files
.terraformrc
terraform.rc

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

### 3. Environment Variable Management
```bash
# .env file (DO NOT commit to Git)
ARM_SUBSCRIPTION_ID="your-subscription-id"
ARM_TENANT_ID="your-tenant-id"
ARM_CLIENT_ID="your-client-id"
ARM_CLIENT_SECRET="your-client-secret"

TF_VAR_environment="dev"
TF_VAR_location="eastus"
TF_VAR_project_name="workshop"
```

### 4. Code Quality Automation
```bash
# Pre-commit hooks
#!/bin/sh
# .git/hooks/pre-commit

# Format Terraform code
terraform fmt -recursive

# Validate Terraform configuration
terraform validate

# Run security scan
tfsec .

# Add formatted files to commit
git add .
```

---

## Next Steps

After completing environment setup:

1. **Validate Environment**: Complete all checklist items above
2. **Create First Project**: Set up a basic Terraform project structure
3. **Practice Basic Commands**: Initialize, plan, apply a simple configuration
4. **Explore VS Code Features**: Learn debugging and IntelliSense capabilities
5. **Set Up Automation**: Configure pre-commit hooks and formatting

**Ready for the next session**: [Building Basic Terraform Configs](02-terraform-fundamentals.md)

---

## Quick Reference Commands

### Daily Development Workflow
```bash
# Start of day
az account show                    # Verify Azure login
cd project-directory
terraform init                    # Initialize if needed

# Development cycle
terraform fmt                     # Format code
terraform validate               # Check syntax
terraform plan                   # Preview changes
terraform apply                  # Apply changes
git add . && git commit -m "msg" # Save progress

# End of day
terraform plan                   # Verify clean state
git push origin feature-branch   # Push changes
```

### Troubleshooting Commands
```bash
# Environment diagnostics
az --version && terraform version && git --version
az account show
terraform version
code --version

# Authentication refresh
az logout && az login
az account set --subscription "subscription-name"

# Clean Terraform state
rm -rf .terraform
terraform init
```

---

*This completes the environment setup fundamentals. A properly configured environment is the foundation for successful Infrastructure as Code development.*
