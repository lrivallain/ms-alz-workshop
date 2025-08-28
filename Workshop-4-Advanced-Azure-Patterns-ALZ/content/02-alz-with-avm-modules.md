# Module 2: ALZ with Azure Verified Modules (AVM)

## Learning Objectives
After completing this module, you will be able to:
- Deploy Azure Landing Zone management groups using AVM.
- Configure hub-and-spoke networking with AVM.
- Understand the principles of composing AVM modules to build a platform.

## Prerequisites
- Completion of Module 1 (ALZ Fundamentals)
- Azure subscription with Management Group permissions
- Terraform >= 1.5 installed
- Azure CLI authenticated to your tenant

## What are Azure Verified Modules (AVM)?

Azure Verified Modules are Microsoft's **officially supported** Terraform modules that follow strict quality standards and best practices. They are the building blocks for creating Azure infrastructure in a standardized, repeatable, and secure way.

### AVM Module Types

1.  **Resource Modules** (`avm-res-*`): Deploy individual Azure resources.
    -   Example: `avm-res-storage-storageaccount`, `avm-res-keyvault-vault`

2.  **Pattern Modules** (`avm-ptn-*`): Deploy architectural patterns composed of multiple resources.
    -   Example: `avm-ptn-alz` (deploys the entire ALZ management group hierarchy), `avm-ptn-alz-connectivity-hub-and-spoke-vnet`

## Manual AVM Composition for Platform Landing Zones

In this module, we will manually build the core components of a Platform Landing Zone by composing several AVM pattern modules. This approach provides a deep understanding of how the components fit together.

**Note**: While this is a great learning exercise, for most production scenarios, Microsoft recommends using the [ALZ Terraform Accelerator](03-alz-terraform-accelerator.md), which automates much of this process.

### Step 1: Bootstrap Management Groups and Policies

First, we establish the foundational Management Group hierarchy and assign core policies using the `avm-ptn-alz` module.

**Create a new directory for your bootstrap configuration:**

```bash
mkdir alz-bootstrap
cd alz-bootstrap
```

**File: `main.tf`**

```terraform
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Configuration for your remote state
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# This module deploys the standard ALZ management group hierarchy
# and a comprehensive set of default policy assignments.
module "alz_management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.8" # Use a specific, stable version

  # The root of your ALZ structure.
  # Use a prefix to avoid conflicts with other root-level management groups.
  root_management_group_name = "MyCompanyALZ"
  root_management_group_id   = "my-company-alz"

  # All other parameters are optional and will use sensible defaults
  # based on the ALZ conceptual architecture.
}
```

### Step 2: Deploy Connectivity Platform (Hub Network)

Next, we create the central hub network. We use a separate Terraform configuration and state file for this to separate concerns.

**Create a new directory for connectivity:**

```bash
mkdir alz-connectivity
cd alz-connectivity
```

**File: `main.tf`**
```terraform
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Configuration for your remote state (e.g., platform/connectivity/terraform.tfstate)
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "East US"
}

# The AVM connectivity module deploys a hub VNet, Azure Firewall,
# Azure Bastion, and a VPN Gateway with best practices.
module "alz_connectivity" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "~> 0.2" # Use a specific, stable version

  # Provide basic configuration for the hub network.
  # The module handles the creation of the resource group.
  hub_virtual_network_name = "vnet-hub-eus"
  hub_location             = var.location
  hub_address_space        = ["10.0.0.0/16"]

  # Enable or disable components as needed.
  # The module uses secure defaults for all underlying resources.
  enable_azure_firewall = true
  enable_azure_bastion  = true
  enable_vpn_gateway    = false # Set to true for hybrid connectivity
}
```

### Step 3: Deploy Management Platform

Finally, we deploy the centralized management and monitoring resources, like Log Analytics.

**Create a directory for the management platform:**
```bash
mkdir alz-management
cd alz-management
```

**File: `main.tf`**
```terraform
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Configuration for your remote state (e.g., platform/management/terraform.tfstate)
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "East US"
}

# The AVM management module deploys a Log Analytics workspace
# and an Automation Account, and configures Defender for Cloud.
module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.1" # Use a specific, stable version

  location = var.location

  # The module handles the creation of the resource group
  # and the configuration of the Log Analytics workspace and solutions.
}
```

## Key Takeaways

-   AVM **Pattern Modules** (`avm-ptn-*`) are high-level abstractions that deploy entire architectural patterns with secure defaults.
-   You build a platform by **composing** these modules in separate, state-managed configurations.
-   When using pattern modules, you provide high-level configuration and trust the module to implement the low-level details according to best practices. This is different from manually configuring every resource.

---

**Next Module**: [Module 3: ALZ Terraform Accelerator](03-alz-terraform-accelerator.md)
