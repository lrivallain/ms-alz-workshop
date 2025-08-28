# Module 4: Subscription Vending with Landing Zone Vending Module

## Learning Objectives
After completing this module, you will be able to:
- Create and manage Azure subscriptions using the Landing Zone Vending module
- Standardize workload environments with automated scaffolding
- Implement enterprise governance patterns (budgets, RBAC, tagging)
- Connect workload landing zones to platform services
- Scale subscription management across multiple teams and environments

## Prerequisites
- Completion of Module 2 (ALZ with AVM) and Module 3 (ALZ Accelerator)
- Azure subscription with EA/MCA billing account access (for subscription creation)
- Understanding of Azure networking concepts

## What is Landing Zone Vending?

**Landing Zone Vending** is the process of **automatically creating and configuring** standardized workload environments (subscriptions) with all the necessary scaffolding for applications.

Think of it as a "**vending machine for cloud environments**" - teams request a landing zone, and they get a fully configured subscription with:
- ✅ Proper management group placement
- ✅ Standardized networking (connected to hub)
- ✅ Resource group layout
- ✅ RBAC assignments
- ✅ Budgets and cost management
- ✅ Managed identities for CI/CD
- ✅ Compliance and governance

### The Landing Zone Vending Module

The `Azure/lz-vending/azurerm` module is Microsoft's **official solution** for subscription lifecycle management in Azure Landing Zones.

**Key Capabilities:**
- 🏗️ **Subscription Creation**: Automated provisioning with EA/MCA billing
- 📋 **Management Group Association**: Automatic placement in ALZ hierarchy
- 🌐 **Network Provisioning**: Hub-spoke, vWAN, or mesh peering
- 👤 **Identity Management**: User-assigned managed identities + federated credentials
- 💰 **Budget Management**: Automated cost controls and alerting
- 🏷️ **Governance**: Tags, RBAC, resource providers, compliance

## Understanding the Vending Process

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Request Comes  │    │   Vending       │    │   Configured    │
│     From        │───▶│   Module        │───▶│   Landing       │
│   Team/App      │    │   Provisions    │    │     Zone        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ Standardized    │
                    │ Components:     │
                    │ • Subscription  │
                    │ • Networking    │
                    │ • Resource Groups│
                    │ • RBAC         │
                    │ • Budgets      │
                    │ • Identities   │
                    └─────────────────┘
```

## Step 1: Basic Landing Zone Vending

Let's start with a simple example that creates a development landing zone.

Create a new directory for landing zone vending:

```bash
mkdir lz-vending
cd lz-vending
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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    key                  = "landing-zones/dev-environment/terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

# Reference platform outputs (connectivity hub)
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    # Adjust this key to match the remote state key of your connectivity platform deployment.
    # If you followed Module 2, the key will likely be "platform/connectivity/terraform.tfstate".
    # If you used the Accelerator in Module 3, check the generated backend configuration.
    key                  = "platform/connectivity/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# Generate unique suffix
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Basic Development Landing Zone
module "dev_landing_zone" {
  source  = "Azure/lz-vending/azurerm"
  version = "~> 5.2"

  # Basic Configuration
  location = var.primary_location

  # Subscription Management
  subscription_alias_enabled = var.create_subscription
  subscription_billing_scope = var.billing_scope  # Required if creating subscription
  subscription_display_name  = "Development Environment - ${var.application_name}"
  subscription_alias_name    = "dev-${var.application_name}-${random_string.suffix.result}"
  subscription_workload      = "DevTest"  # Options: Production, DevTest

  # Management Group Placement
  subscription_management_group_association_enabled = true
  subscription_management_group_id = var.dev_management_group_id  # e.g., "alz-corp" or "alz-sandbox"

  # Subscription Tags
  subscription_tags = {
    Environment   = "Development"
    Application   = var.application_name
    CostCenter    = var.cost_center
    Owner         = var.team_email
    Purpose       = "Application Development"
    CreatedBy     = "Terraform-LZ-Vending"
    CreatedDate   = timestamp()
  }

  # Register Required Resource Providers
  subscription_register_resource_providers_enabled = true
  subscription_register_resource_providers_and_features = {
    "Microsoft.Compute"                = []
    "Microsoft.Storage"                = []
    "Microsoft.Network"                = []
    "Microsoft.KeyVault"               = []
    "Microsoft.Web"                    = []
    "Microsoft.Sql"                    = []
    "Microsoft.Insights"               = []
    "Microsoft.OperationalInsights"    = []
    "Microsoft.Security"               = []
    "Microsoft.Authorization"          = []
    "Microsoft.Resources"              = []
  }

  # Virtual Network Configuration
  virtual_network_enabled = true
  virtual_networks = {
    primary = {
      name                = "vnet-${var.application_name}-dev-${random_string.suffix.result}"
      address_space       = [var.vnet_address_space]
      resource_group_name = "rg-${var.application_name}-dev-network"
      location           = var.primary_location

      # Connect to platform hub (if available)
      hub_peering_enabled = var.enable_hub_peering
      hub_network_resource_id = var.hub_network_resource_id

      # Standard subnet layout for applications
      subnets = {
        # Application subnet
        app = {
          name             = "snet-app"
          address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 1)]  # First /24 subnet
          service_endpoints = [
            "Microsoft.Storage",
            "Microsoft.KeyVault",
            "Microsoft.Sql"
          ]
        }
        
        # Database subnet
        data = {
          name             = "snet-data"
          address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 2)]  # Second /24 subnet
          service_endpoints = ["Microsoft.Sql"]
        }
        
        # Management subnet
        mgmt = {
          name             = "snet-mgmt"
          address_prefixes = [cidrsubnet(var.vnet_address_space, 8, 10)] # Tenth /24 subnet
          service_endpoints = ["Microsoft.Storage"]
        }
      }

      # DNS configuration (use hub DNS if available)
      dns_servers = var.hub_dns_servers

      tags = {
        Environment = "Development"
        Purpose     = "Application Network"
      }
    }
  }

  # Resource Group Management
  resource_group_creation_enabled = true
  resource_groups = {
    # Application workloads
    app = {
      name     = "rg-${var.application_name}-dev-app"
      location = var.primary_location
      tags = {
        Purpose = "Application Resources"
      }
    }
    
    # Data resources (databases, storage)
    data = {
      name     = "rg-${var.application_name}-dev-data"
      location = var.primary_location
      tags = {
        Purpose = "Data Resources"
      }
    }
    
    # Security resources (key vault, certificates)
    security = {
      name     = "rg-${var.application_name}-dev-security"
      location = var.primary_location
      tags = {
        Purpose = "Security Resources"
      }
    }
    
    # Monitoring resources
    monitoring = {
      name     = "rg-${var.application_name}-dev-monitoring"
      location = var.primary_location
      tags = {
        Purpose = "Monitoring and Observability"
      }
    }
    
    # Network resources (NSGs, route tables, etc.)
    network = {
      name     = "rg-${var.application_name}-dev-network"
      location = var.primary_location
      tags = {
        Purpose = "Network Resources"
      }
    }
    
    # Required for Network Watcher
    NetworkWatcherRG = {
      name     = "NetworkWatcherRG"
      location = var.primary_location
      tags = {
        Purpose = "Network Watcher"
      }
    }
  }

  # Role-Based Access Control
  role_assignment_enabled = true
  role_assignments = {
    # Development team gets Owner access to their environment
    dev_team_owners = {
      principal_id               = var.dev_team_group_id
      role_definition_id_or_name = "Owner"
      description               = "Development team full access"
      principal_type            = "Group"  # Options: User, Group, ServicePrincipal
    }
    
    # Platform team gets Contributor access for support
    platform_contributors = {
      principal_id               = var.platform_team_group_id  
      role_definition_id_or_name = "Contributor"
      description               = "Platform team support access"
      principal_type            = "Group"
    }
    
    # Security team gets Security Reader access
    security_readers = {
      principal_id               = var.security_team_group_id
      role_definition_id_or_name = "Security Reader"
      description               = "Security team monitoring access"
      principal_type            = "Group"
    }
  }

  # Budget Management
  budget_enabled = true
  budgets = {
    monthly_budget = {
      amount            = var.monthly_budget_amount
      time_grain        = "Monthly"
      time_period_start = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
      time_period_end   = "2025-12-31T23:59:59Z"

      # Budget notifications
      notifications = {
        # Warning at 50%
        warning_50 = {
          enabled   = true
          threshold = 50
          operator  = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = [var.team_email]
          contact_roles  = ["Owner"]
          contact_groups = []
        }

        # Critical at 80%  
        critical_80 = {
          enabled   = true
          threshold = 80
          operator  = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = [var.team_email, var.finance_email]
          contact_roles  = ["Owner", "Contributor"]
          contact_groups = []
        }

        # Alert at 100% (forecasted)
        alert_100_forecast = {
          enabled   = true
          threshold = 100
          operator  = "GreaterThan"
          threshold_type = "Forecasted"
          contact_emails = [var.team_email, var.finance_email, var.management_email]
          contact_roles  = ["Owner"]
          contact_groups = []
        }
      }

      # Filter budget to specific resource groups (optional)
      filter = {
        dimensions = {
          name = "ResourceGroupName"
          operator = "In"
          values = [
            "rg-${var.application_name}-dev-app",
            "rg-${var.application_name}-dev-data",
            "rg-${var.application_name}-dev-security"
          ]
        }
      }
    }
  }
}
```

**File: `variables.tf`**
```terraform
variable "primary_location" {
  description = "Primary Azure region for deployments"
  type        = string
  default     = "East US"
}

variable "application_name" {
  description = "Name of the application (used in resource naming)"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]{2,20}$", var.application_name))
    error_message = "Application name must be 2-20 lowercase alphanumeric characters."
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = string
  default     = "10.200.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vnet_address_space, 0))
    error_message = "VNet address space must be a valid CIDR block."
  }
}

variable "create_subscription" {
  description = "Create a new subscription (requires billing scope)"
  type        = bool
  default     = false  # Set to true if you want to create a new subscription
}

variable "billing_scope" {
  description = "Billing scope for subscription creation (EA or MCA enrollment account)"
  type        = string
  default     = null
  # Example: "/providers/Microsoft.Billing/billingAccounts/12345/enrollmentAccounts/67890"
}

variable "dev_management_group_id" {
  description = "Management group ID for development subscriptions"
  type        = string
  # Example: "alz-landingzones-corp" or get from your ALZ outputs
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "IT-001"
}

variable "team_email" {
  description = "Primary team email for notifications"
  type        = string
}

variable "finance_email" {
  description = "Finance team email for budget alerts"
  type        = string
  default     = "finance@contoso.com"
}

variable "management_email" {
  description = "Management email for critical alerts"
  type        = string
  default     = "management@contoso.com"
}

variable "monthly_budget_amount" {
  description = "Monthly budget amount for the environment"
  type        = number
  default     = 1000
  
  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "Budget amount must be greater than 0."
  }
}

variable "dev_team_group_id" {
  description = "Azure AD group ID for development team"
  type        = string
  # You can get this with: az ad group show --group "Dev Team" --query id -o tsv
}

variable "platform_team_group_id" {
  description = "Azure AD group ID for platform team"
  type        = string
  default     = null
}

variable "security_team_group_id" {
  description = "Azure AD group ID for security team"
  type        = string
  default     = null
}

variable "enable_hub_peering" {
  description = "Enable peering to platform hub network"
  type        = bool
  default     = true
}

variable "hub_network_resource_id" {
  description = "Resource ID of the platform hub network"
  type        = string
  default     = null
  # You can get this from your platform outputs
}

variable "hub_dns_servers" {
  description = "DNS servers from the hub network"
  type        = list(string)
  default     = []  # Empty list means use Azure default DNS
}
```

**File: `terraform.tfvars.example`**
```terraform
# Copy this file to terraform.tfvars and customize values

# Basic configuration
application_name    = "ecommerce"
team_email         = "dev-team@contoso.com"
cost_center        = "ECOM-001"

# Budget
monthly_budget_amount = 2000

# Azure AD Groups (get these from your AD admin)
dev_team_group_id      = "12345678-1234-1234-1234-123456789012"
platform_team_group_id = "87654321-4321-4321-4321-210987654321"
security_team_group_id = "11111111-2222-3333-4444-555555555555"

# Management Group (get from your ALZ outputs)
dev_management_group_id = "alz-landingzones-corp"

# Networking (if connecting to hub)
enable_hub_peering      = true
hub_network_resource_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-connectivity-hub/providers/Microsoft.Network/virtualNetworks/hub-vnet"
hub_dns_servers        = ["10.0.1.4", "10.0.1.5"]

# Subscription creation (only if you have billing access)
create_subscription = false
# billing_scope = "/providers/Microsoft.Billing/billingAccounts/12345/enrollmentAccounts/67890"
```

**File: `outputs.tf`**
```terraform
output "subscription_id" {
  description = "ID of the landing zone subscription"
  value       = module.dev_landing_zone.subscription_id
}

output "virtual_network_resource_ids" {
  description = "Resource IDs of created virtual networks"
  value       = module.dev_landing_zone.virtual_network_resource_ids
}

output "resource_group_resource_ids" {
  description = "Resource IDs of created resource groups"
  value       = module.dev_landing_zone.resource_group_resource_ids
}

output "resource_groups" {
  description = "Map of resource group names to their properties"
  value = {
    for name, rg in module.dev_landing_zone.resource_group_resource_ids :
    name => {
      id   = rg
      name = split("/", rg)[4]  # Extract RG name from resource ID
    }
  }
}
```

## Step 2: Deploy the Development Landing Zone

### Configure Variables

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your specific values
# You'll need:
# - Azure AD group IDs for your teams
# - Management group ID from your ALZ deployment
# - Hub network resource ID (if connecting to hub)
```

### Deploy

```bash
# Initialize
terraform init

# Plan the deployment
terraform plan

# Apply (this may take 10-15 minutes if creating a subscription)
terraform apply
```

### What Gets Created

After deployment, you'll have:

1. **Subscription** (if `create_subscription = true`)
2. **Management Group Placement**
3. **Virtual Network** with standard subnets
4. **Resource Groups** for different purposes
5. **RBAC Assignments** for teams
6. **Budget** with cost alerts
7. **Resource Provider Registrations**

## Step 3: Enterprise Production Landing Zone

Now let's create a more sophisticated production landing zone with advanced features.

Create a new directory:

```bash
mkdir ../production-lz
cd ../production-lz
```

**File: `main.tf`** (Production configuration with advanced features)
```terraform
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    key                  = "landing-zones/production/terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Production Landing Zone with Advanced Features
module "production_landing_zone" {
  source  = "Azure/lz-vending/azurerm"
  version = "~> 5.2"

  location = var.primary_location

  # Subscription Management
  subscription_alias_enabled = var.create_subscription
  subscription_billing_scope = var.billing_scope
  subscription_display_name  = "Production - ${var.application_name}"
  subscription_alias_name    = "prod-${var.application_name}-${random_string.suffix.result}"
  subscription_workload      = "Production"

  # Management Group Placement
  subscription_management_group_association_enabled = true
  subscription_management_group_id = var.prod_management_group_id

  # Production Tags
  subscription_tags = {
    Environment     = "Production"
    Application     = var.application_name
    CostCenter      = var.cost_center
    Owner           = var.team_email
    BusinessCriticality = "High"
    DataClassification = "Confidential"
    BackupRequired  = "Yes"
    DR_Required     = "Yes"
    Compliance      = join(",", var.compliance_frameworks)
    CreatedBy       = "Terraform-LZ-Vending"
  }

  # Resource Providers
  subscription_register_resource_providers_enabled = true
  subscription_register_resource_providers_and_features = {
    "Microsoft.Compute"                = []
    "Microsoft.Storage"                = []
    "Microsoft.Network"                = []
    "Microsoft.KeyVault"               = []
    "Microsoft.Web"                    = []
    "Microsoft.Sql"                    = []
    "Microsoft.Cache"                  = []  # Redis Cache
    "Microsoft.CDN"                    = []  # Content Delivery Network
    "Microsoft.Insights"               = []
    "Microsoft.OperationalInsights"    = []
    "Microsoft.Security"               = []
    "Microsoft.Authorization"          = []
    "Microsoft.Resources"              = []
    "Microsoft.Monitor"                = []
    "Microsoft.AlertsManagement"       = []
  }

  # Multi-Region Virtual Networks
  virtual_network_enabled = true
  virtual_networks = {
    # Primary region network
    primary = {
      name                = "vnet-${var.application_name}-prod-primary-${random_string.suffix.result}"
      address_space       = [var.primary_vnet_address_space]
      resource_group_name = "rg-${var.application_name}-prod-network-primary"
      location           = var.primary_location

      # Connect to platform hub
      hub_peering_enabled     = true
      hub_network_resource_id = var.hub_network_resource_id

      # Production subnet layout
      subnets = {
        # Web tier (public-facing)
        web = {
          name             = "snet-web"
          address_prefixes = [cidrsubnet(var.primary_vnet_address_space, 8, 1)]
          service_endpoints = [
            "Microsoft.Storage",
            "Microsoft.KeyVault",
            "Microsoft.Web"
          ]
        }
        
        # Application tier
        app = {
          name             = "snet-app"
          address_prefixes = [cidrsubnet(var.primary_vnet_address_space, 8, 2)]
          service_endpoints = [
            "Microsoft.Storage",
            "Microsoft.KeyVault",
            "Microsoft.Sql"
          ]
        }
        
        # Database tier
        data = {
          name             = "snet-data"
          address_prefixes = [cidrsubnet(var.primary_vnet_address_space, 8, 3)]
          service_endpoints = ["Microsoft.Sql"]
        }
        
        # Integration services (Logic Apps, Service Bus, etc.)
        integration = {
          name             = "snet-integration"
          address_prefixes = [cidrsubnet(var.primary_vnet_address_space, 8, 4)]
          service_endpoints = [
            "Microsoft.ServiceBus",
            "Microsoft.Storage"
          ]
        }
        
        # Management and monitoring
        mgmt = {
          name             = "snet-mgmt"
          address_prefixes = [cidrsubnet(var.primary_vnet_address_space, 8, 10)]
          service_endpoints = [
            "Microsoft.Storage",
            "Microsoft.OperationalInsights"
          ]
        }
      }

      dns_servers = var.hub_dns_servers
      
      tags = {
        Environment = "Production"
        Purpose     = "Primary Application Network"
        Region      = "Primary"
      }
    }

    # Secondary region network (for DR)
    secondary = var.enable_disaster_recovery ? {
      name                = "vnet-${var.application_name}-prod-secondary-${random_string.suffix.result}"
      address_space       = [var.secondary_vnet_address_space]
      resource_group_name = "rg-${var.application_name}-prod-network-secondary"
      location           = var.secondary_location

      # Connect to secondary hub (if available)
      hub_peering_enabled     = var.secondary_hub_network_resource_id != null
      hub_network_resource_id = var.secondary_hub_network_resource_id

      # Mirror primary subnets in secondary region
      subnets = {
        web = {
          name             = "snet-web"
          address_prefixes = [cidrsubnet(var.secondary_vnet_address_space, 8, 1)]
          service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        }
        app = {
          name             = "snet-app"
          address_prefixes = [cidrsubnet(var.secondary_vnet_address_space, 8, 2)]
          service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
        }
        data = {
          name             = "snet-data"
          address_prefixes = [cidrsubnet(var.secondary_vnet_address_space, 8, 3)]
          service_endpoints = ["Microsoft.Sql"]
        }
      }

      tags = {
        Environment = "Production"
        Purpose     = "DR Application Network"
        Region      = "Secondary"
      }
    } : {}
  }

  # Network Security Groups
  network_security_group_enabled = true
  network_security_groups = {
    web_nsg = {
      name                = "nsg-web-prod"
      resource_group_name = "rg-${var.application_name}-prod-network-primary"
      location           = var.primary_location

      security_rules = {
        allow_https = {
          name                       = "Allow-HTTPS-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
        
        allow_http_redirect = {
          name                       = "Allow-HTTP-Redirect"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
        
        deny_all_inbound = {
          name                       = "Deny-All-Inbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      }
    }

    app_nsg = {
      name                = "nsg-app-prod"
      resource_group_name = "rg-${var.application_name}-prod-network-primary"
      location           = var.primary_location

      security_rules = {
        allow_web_to_app = {
          name                       = "Allow-Web-to-App"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["80", "443", "8080", "8443"]
          source_address_prefix      = cidrsubnet(var.primary_vnet_address_space, 8, 1)
          destination_address_prefix = "*"
        }
        
        allow_mgmt_rdp_ssh = {
          name                       = "Allow-Mgmt-RDP-SSH"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_ranges    = ["22", "3389"]
          source_address_prefix      = cidrsubnet(var.primary_vnet_address_space, 8, 10)
          destination_address_prefix = "*"
        }
      }
    }

    data_nsg = {
      name                = "nsg-data-prod"
      resource_group_name = "rg-${var.application_name}-prod-network-primary"
      location           = var.primary_location

      security_rules = {
        allow_app_to_sql = {
          name                       = "Allow-App-to-SQL"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1433"
          source_address_prefix      = cidrsubnet(var.primary_vnet_address_space, 8, 2)
          destination_address_prefix = "*"
        }
      }
    }
  }

  # Comprehensive Resource Groups
  resource_group_creation_enabled = true
  resource_groups = {
    # Primary region resources
    compute_primary = {
      name     = "rg-${var.application_name}-prod-compute-primary"
      location = var.primary_location
      tags     = { Purpose = "Compute Resources", Region = "Primary" }
    }
    
    data_primary = {
      name     = "rg-${var.application_name}-prod-data-primary"
      location = var.primary_location
      tags     = { Purpose = "Data Resources", Region = "Primary" }
    }
    
    security_primary = {
      name     = "rg-${var.application_name}-prod-security-primary"
      location = var.primary_location
      tags     = { Purpose = "Security Resources", Region = "Primary" }
    }
    
    monitoring = {
      name     = "rg-${var.application_name}-prod-monitoring"
      location = var.primary_location
      tags     = { Purpose = "Monitoring and Observability" }
    }
    
    integration = {
      name     = "rg-${var.application_name}-prod-integration"
      location = var.primary_location
      tags     = { Purpose = "Integration Services" }
    }
    
    network_primary = {
      name     = "rg-${var.application_name}-prod-network-primary"
      location = var.primary_location
      tags     = { Purpose = "Network Resources", Region = "Primary" }
    }

    # Secondary region resources (for DR)
    compute_secondary = var.enable_disaster_recovery ? {
      name     = "rg-${var.application_name}-prod-compute-secondary"
      location = var.secondary_location
      tags     = { Purpose = "Compute Resources", Region = "Secondary" }
    } : {}
    
    data_secondary = var.enable_disaster_recovery ? {
      name     = "rg-${var.application_name}-prod-data-secondary"
      location = var.secondary_location
      tags     = { Purpose = "Data Resources", Region = "Secondary" }
    } : {}
    
    network_secondary = var.enable_disaster_recovery ? {
      name     = "rg-${var.application_name}-prod-network-secondary"
      location = var.secondary_location
      tags     = { Purpose = "Network Resources", Region = "Secondary" }
    } : {}

    # Global resources
    global = {
      name     = "rg-${var.application_name}-prod-global"
      location = var.primary_location
      tags     = { Purpose = "Global Resources" }
    }

    # Required system resource groups
    NetworkWatcherRG = {
      name     = "NetworkWatcherRG"
      location = var.primary_location
      tags     = { Purpose = "Network Watcher" }
    }
  }

  # Enterprise RBAC
  role_assignment_enabled = true
  role_assignments = {
    # Application team gets Contributor access (not Owner in production)
    app_team_contributors = {
      principal_id               = var.app_team_group_id
      role_definition_id_or_name = "Contributor"
      description               = "Application team deployment access"
      principal_type            = "Group"
    }
    
    # Operations team gets full access
    ops_team_owners = {
      principal_id               = var.ops_team_group_id
      role_definition_id_or_name = "Owner"
      description               = "Operations team full access"
      principal_type            = "Group"
    }
    
    # Platform team gets Contributor access
    platform_contributors = {
      principal_id               = var.platform_team_group_id
      role_definition_id_or_name = "Contributor"
      description               = "Platform team support access"
      principal_type            = "Group"
    }
    
    # Security team gets Security Admin access
    security_admins = {
      principal_id               = var.security_team_group_id
      role_definition_id_or_name = "Security Admin"
      description               = "Security team administrative access"
      principal_type            = "Group"
    }
    
    # Monitoring readers
    monitoring_readers = {
      principal_id               = var.monitoring_team_group_id
      role_definition_id_or_name = "Monitoring Reader"
      description               = "Monitoring team read access"
      principal_type            = "Group"
    }
  }

  # CI/CD Managed Identities
  user_managed_identities = {
    # Primary CI/CD identity
    cicd_primary = {
      name                = "id-${var.application_name}-prod-cicd"
      resource_group_name = "rg-${var.application_name}-prod-security-primary"
      location           = var.primary_location

      # Role assignments for deployment
      role_assignments = {
        contributor = {
          role_definition_id_or_name = "Contributor"
          scope                      = ""  # Subscription scope
          description               = "CI/CD deployment permissions"
        }
        
        key_vault_secrets_officer = {
          role_definition_id_or_name = "Key Vault Secrets Officer"
          relative_scope            = "/resourceGroups/rg-${var.application_name}-prod-security-primary"
          description               = "CI/CD secret management"
        }
      }

      # GitHub Actions OIDC integration
      federated_credentials_github = {
        main_branch = {
          organization = var.github_organization
          repository   = var.github_repository
          entity       = "branch"
          value        = "main"
        }
        
        release_branches = {
          organization = var.github_organization
          repository   = var.github_repository
          entity       = "branch"
          value        = "release/*"
        }
      }

      tags = {
        Purpose = "CI/CD Automation"
      }
    }
  }

  # Production Budget Management
  budget_enabled = true
  budgets = {
    # Monthly operational budget
    monthly_operational = {
      amount            = var.monthly_budget_amount
      time_grain        = "Monthly"
      time_period_start = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
      time_period_end   = "2025-12-31T23:59:59Z"

      notifications = {
        warning_50 = {
          enabled        = true
          threshold      = 50
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = [var.team_email, var.finance_email]
          contact_roles  = ["Owner", "Contributor"]
        }
        
        critical_75 = {
          enabled        = true
          threshold      = 75
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = [var.team_email, var.finance_email, var.ops_email]
          contact_roles  = ["Owner"]
        }
        
        emergency_90_forecast = {
          enabled        = true
          threshold      = 90
          operator       = "GreaterThan"
          threshold_type = "Forecasted"
          contact_emails = [var.management_email, var.finance_email]
        }
      }
    }
    
    # Quarterly budget for planning
    quarterly_planning = {
      amount            = var.monthly_budget_amount * 3
      time_grain        = "Quarterly"
      time_period_start = formatdate("YYYY-MM-01'T'00:00:00'Z'", timestamp())
      time_period_end   = "2025-12-31T23:59:59Z"

      notifications = {
        quarterly_review = {
          enabled        = true
          threshold      = 90
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = [var.finance_email, var.management_email]
        }
      }
    }
  }

  # Route Tables for Traffic Control
  route_table_enabled = true
  route_tables = {
    primary_routes = {
      name                          = "rt-${var.application_name}-prod-primary"
      location                      = var.primary_location
      resource_group_name           = "rg-${var.application_name}-prod-network-primary"
      bgp_route_propagation_enabled = false

      routes = {
        default_to_firewall = {
          name                   = "default-to-firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.firewall_private_ip
        }
        
        to_secondary_region = var.enable_disaster_recovery ? {
          name           = "to-secondary-region"
          address_prefix = var.secondary_vnet_address_space
          next_hop_type  = "VirtualNetworkGateway"
        } : {}
      }
    }
  }
}
```

This production configuration is getting quite long. Let me create the variables and outputs files, then show you how to deploy and manage this enterprise-scale landing zone.

**File: `variables.tf`** (Production variables)
```terraform
    ]
  }

  # Managed identities for CI/CD and applications
  user_managed_identities = {
    # Primary identity for CI/CD operations
    cicd_primary = {
      name     = "id-cicd-${var.application_name}-${var.environment}-primary"
      location = var.primary_location
      resource_group_key = "security_primary"
      
      # Federated credentials for GitHub Actions OIDC
      federated_credentials = {
        github_main = {
          display_name = "GitHub-${var.github_repository}-main"
          description  = "GitHub Actions OIDC for main branch"
          issuer       = "https://token.actions.githubusercontent.com"
          subject      = "repo:${var.github_organization}/${var.github_repository}:ref:refs/heads/main"
          audiences    = ["api://AzureADTokenExchange"]
        }
        github_pr = {
          display_name = "GitHub-${var.github_repository}-pr"
          description  = "GitHub Actions OIDC for pull requests"
          issuer       = "https://token.actions.githubusercontent.com"
          subject      = "repo:${var.github_organization}/${var.github_repository}:pull_request"
          audiences    = ["api://AzureADTokenExchange"]
        }
      }
    }

    # Application identity for runtime operations
    app_primary = {
      name     = "id-app-${var.application_name}-${var.environment}-primary"
      location = var.primary_location
      resource_group_key = "security_primary"
    }

    # Secondary region identity for DR scenarios
    cicd_secondary = {
      name     = "id-cicd-${var.application_name}-${var.environment}-secondary"
      location = var.secondary_location
      resource_group_key = "security_secondary"
    }
  }

  # RBAC role assignments across the landing zone
  role_assignments = {
    # Landing zone owner access
    lz_owner = {
      principal_id         = var.landing_zone_owner_object_id
      role_definition_name = "Owner"
      scope               = "landing_zone"  # Applies to entire landing zone
    }

    # Application team access to compute resources
    app_team_compute = {
      principal_id         = var.app_team_security_group_id
      role_definition_name = "Contributor"
      scope               = "resource_group"
      resource_group_key   = "compute_primary"
    }

    # Application team access to data resources
    app_team_data = {
      principal_id         = var.app_team_security_group_id
      role_definition_name = "Contributor" 
      scope               = "resource_group"
      resource_group_key   = "data_primary"
    }

    # DevOps team access to monitoring
    devops_team_monitoring = {
      principal_id         = var.devops_team_security_group_id
      role_definition_name = "Monitoring Contributor"
      scope               = "resource_group"
      resource_group_key   = "monitoring"
    }

    # CI/CD identity permissions
    cicd_contributor = {
      principal_id         = "user_managed_identity:cicd_primary"  # Reference to UMI
      role_definition_name = "Contributor"
      scope               = "landing_zone"
    }

    # Network team access to networking resources
    network_team = {
      principal_id         = var.network_team_security_group_id
      role_definition_name = "Network Contributor"
      scope               = "resource_group"
      resource_group_key   = "network_primary"
    }
  }

  # Budget configuration with comprehensive alerting
  budgets = {
    monthly_budget = {
      name        = "budget-${var.application_name}-${var.environment}-monthly"
      amount      = var.monthly_budget_amount
      time_grain  = "Monthly"
      
      # Multiple budget alert thresholds
      notifications = {
        # Warning at 50% of budget
        warning_50 = {
          enabled        = true
          threshold      = 50
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = var.budget_alert_emails
          contact_groups = var.budget_alert_action_groups
          contact_roles  = ["Owner", "Contributor"]
        }
        
        # Alert at 75% of budget  
        alert_75 = {
          enabled        = true
          threshold      = 75
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = var.budget_alert_emails
          contact_groups = var.budget_alert_action_groups
          contact_roles  = ["Owner", "Contributor"]
        }
        
        # Critical alert at 90% of budget
        critical_90 = {
          enabled        = true
          threshold      = 90
          operator       = "GreaterThan" 
          threshold_type = "Actual"
          contact_emails = var.budget_alert_emails
          contact_groups = var.budget_alert_action_groups
          contact_roles  = ["Owner", "Contributor"]
        }
        
        # Forecasted alert at 100% of budget
        forecast_100 = {
          enabled        = true
          threshold      = 100
          operator       = "GreaterThan"
          threshold_type = "Forecasted"
          contact_emails = var.budget_alert_emails
          contact_groups = var.budget_alert_action_groups
          contact_roles  = ["Owner", "Contributor"]
        }
      }
    }
    
    # Quarterly budget for longer-term planning
    quarterly_budget = {
      name        = "budget-${var.application_name}-${var.environment}-quarterly"
      amount      = var.monthly_budget_amount * 3
      time_grain  = "Quarterly"
      
      notifications = {
        alert_80 = {
          enabled        = true
          threshold      = 80
          operator       = "GreaterThan"
          threshold_type = "Actual"
          contact_emails = var.budget_alert_emails
          contact_groups = var.budget_alert_action_groups
          contact_roles  = ["Owner"]
        }
      }
    }
  }

  tags = merge(local.common_tags, {
    Environment     = var.environment
    Application     = var.application_name
    BusinessUnit    = var.business_unit
    CostCenter      = var.cost_center
    DataClass       = "Confidential"
    Criticality     = "High"
  })
}
```

**File: `variables.tf`**
```terraform
# Environment and application variables
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]{2,20}$", var.application_name))
    error_message = "Application name must be 2-20 lowercase alphanumeric characters."
  }
}

variable "business_unit" {
  description = "Business unit responsible for the application"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
}

# Location variables
variable "primary_location" {
  description = "Primary Azure region"
  type        = string
  default     = "East US"
}

variable "secondary_location" {
  description = "Secondary Azure region for DR"
  type        = string
  default     = "West US 2"
}

# Subscription and management variables
variable "subscription_id" {
  description = "Target subscription ID for the landing zone"
  type        = string
}

variable "billing_account_id" {
  description = "Enterprise Agreement billing account ID"
  type        = string
}

variable "billing_profile_id" {
  description = "Billing profile ID within the billing account"
  type        = string
}

variable "invoice_section_id" {
  description = "Invoice section ID for cost allocation"
  type        = string
}

variable "management_group_id" {
  description = "Parent management group ID for the landing zone"
  type        = string
}

# Access control variables
variable "landing_zone_owner_object_id" {
  description = "Object ID of the landing zone owner"
  type        = string
}

variable "app_team_security_group_id" {
  description = "Security group ID for application team"
  type        = string
}

variable "devops_team_security_group_id" {
  description = "Security group ID for DevOps team"
  type        = string
}

variable "network_team_security_group_id" {
  description = "Security group ID for network team"
  type        = string
}

# GitHub Actions integration
variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

# Budget and cost management
variable "monthly_budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
  
  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "Monthly budget amount must be greater than 0."
  }
}

variable "budget_alert_emails" {
  description = "Email addresses for budget alerts"
  type        = list(string)
  default     = []
}

variable "budget_alert_action_groups" {
  description = "Action group IDs for budget alerts"
  type        = list(string)
  default     = []
}

# Network configuration variables
variable "hub_virtual_network_resource_id" {
  description = "Resource ID of the hub virtual network for peering"
  type        = string
}

variable "primary_vnet_address_space" {
  description = "Address space for the primary virtual network"
  type        = string
  default     = "10.1.0.0/16"
}

variable "hub_dns_servers" {
  description = "DNS servers from the hub network"
  type        = list(string)
  default     = []
}

variable "private_dns_zone_resource_ids" {
  description = "Private DNS zone resource IDs from hub"
  type        = map(string)
  default     = {}
}
```

**File: `outputs.tf`**
```terraform
output "subscription_id" {
  description = "Subscription ID of the created landing zone"
  value       = module.enterprise_production_landing_zone.subscription_id
}

output "resource_groups" {
  description = "Resource group information"
  value       = module.enterprise_production_landing_zone.resource_groups
}

output "virtual_network_resource_ids" {
  description = "Virtual network resource IDs"
  value       = module.enterprise_production_landing_zone.virtual_network_resource_ids
}

output "user_managed_identities" {
  description = "User-assigned managed identity information"
  value       = module.enterprise_production_landing_zone.user_managed_identities
}

output "budgets" {
  description = "Budget configuration and IDs"
  value       = module.enterprise_production_landing_zone.budgets
}

# Outputs for application resources to reference
output "network_info" {
  description = "Network information for application deployment"
  value = {
    vnet_id    = module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]
    subnet_ids = {
      web         = "${module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]}/subnets/snet-web"
      app         = "${module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]}/subnets/snet-app"
      data        = "${module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]}/subnets/snet-data"
      integration = "${module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]}/subnets/snet-integration"
      mgmt        = "${module.enterprise_production_landing_zone.virtual_network_resource_ids["primary"]}/subnets/snet-mgmt"
    }
  }
}

output "security_info" {
  description = "Security information for application deployment"
  value = {
    cicd_identity_client_id    = module.enterprise_production_landing_zone.user_managed_identities["cicd_primary"]["client_id"]
    cicd_identity_principal_id = module.enterprise_production_landing_zone.user_managed_identities["cicd_primary"]["principal_id"]
    app_identity_client_id     = module.enterprise_production_landing_zone.user_managed_identities["app_primary"]["client_id"]
    app_identity_principal_id  = module.enterprise_production_landing_zone.user_managed_identities["app_primary"]["principal_id"]
  }
  sensitive = true
}
```

## Deployment Instructions

### Prerequisites
1. Platform foundation deployed (from Module 2B or 2C)
2. Terraform >= 1.5 installed
3. Azure CLI >= 2.50.0 installed and authenticated
4. Appropriate permissions on target subscription and management group

### Step 1: Configure Variables
Create a `terraform.tfvars` file:

```terraform
# Environment configuration
environment      = "prod"
application_name = "ecommerce"
business_unit    = "Digital Commerce"
cost_center      = "CC-1001"

# Location configuration  
primary_location   = "East US"
secondary_location = "West US 2"

# Azure configuration
subscription_id       = "12345678-1234-1234-1234-123456789012"
billing_account_id   = "12345678-1234-1234-1234-123456789012:12345678-1234-1234-1234-123456789012_2019-05-31"
billing_profile_id   = "ABCD-EFGH-IJKL-MNOP"
invoice_section_id   = "WXYZ-1234-5678-9012"
management_group_id  = "alz-landingzones"

# Access control - replace with actual Object IDs
landing_zone_owner_object_id      = "11111111-1111-1111-1111-111111111111"
app_team_security_group_id        = "22222222-2222-2222-2222-222222222222"
devops_team_security_group_id     = "33333333-3333-3333-3333-333333333333"
network_team_security_group_id    = "44444444-4444-4444-4444-444444444444"

# GitHub Actions integration
github_organization = "contoso"
github_repository   = "ecommerce-app"

# Budget configuration
monthly_budget_amount = 5000
budget_alert_emails = [
  "finance@contoso.com",
  "devops@contoso.com"
]

# Network configuration
primary_vnet_address_space = "10.1.0.0/16"
hub_virtual_network_resource_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-connectivity-hub/providers/Microsoft.Network/virtualNetworks/vnet-connectivity-hub"

private_dns_zone_resource_ids = {
  "privatelink.database.windows.net"     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-connectivity-dns/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"
  "privatelink.blob.core.windows.net"    = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-connectivity-dns/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  "privatelink.vaultcore.azure.net"      = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-connectivity-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
}
```

### Step 2: Initialize and Deploy

```bash
# Initialize Terraform
terraform init -backend-config="key=landing-zones/production/terraform.tfstate"

# Review the deployment plan
terraform plan -var-file="terraform.tfvars"

# Deploy the landing zone
terraform apply -var-file="terraform.tfvars"
```

### Step 3: Verify Deployment

```bash
# Check subscription creation
az account subscription show --subscription-id "your-new-subscription-id"

# Verify resource groups
az group list --subscription "your-new-subscription-id" --query "[].{Name:name, Location:location}" -o table

# Check network configuration
az network vnet list --subscription "your-new-subscription-id" --query "[].{Name:name, AddressSpace:addressSpace.addressPrefixes}" -o table

# Verify managed identities
az identity list --subscription "your-new-subscription-id" --query "[].{Name:name, ClientId:clientId}" -o table
```

## Management and Operations

### Monitoring Deployment Status

```bash
# Monitor subscription provisioning
az account subscription show --subscription-id "your-subscription-id" --query "{Name:displayName, State:state, SubscriptionId:subscriptionId}"

# Check policy compliance
az policy state list --subscription "your-subscription-id" --filter "ComplianceState eq 'NonCompliant'" --query "length(@)"

# Review budget alerts
az consumption budget list --subscription "your-subscription-id" --query "[].{Name:name, Amount:amount, CurrentSpend:currentSpend.amount}" -o table
```

### Security and Compliance

```bash
# Review role assignments
az role assignment list --subscription "your-subscription-id" --query "[].{PrincipalName:principalName, RoleDefinitionName:roleDefinitionName, Scope:scope}" -o table

# Check managed identity configuration
az identity federated-credential list --name "id-cicd-ecommerce-prod-primary" --resource-group "rg-ecommerce-prod-security" --identity-name "id-cicd-ecommerce-prod-primary"
```

## Troubleshooting Common Issues

### Subscription Provisioning Fails
```bash
# Check EA account permissions
az billing account show --account-name "your-billing-account-id"

# Verify billing profile access  
az billing profile show --account-name "your-billing-account-id" --profile-name "your-billing-profile-id"
```

### Network Peering Issues
```bash
# Check hub VNet exists and is accessible
az network vnet show --ids "your-hub-vnet-resource-id"

# Verify peering permissions
az role assignment list --assignee "your-managed-identity-principal-id" --scope "your-hub-vnet-resource-id"
```

### Policy Assignment Conflicts
```bash
# List conflicting policies
az policy state list --subscription "your-subscription-id" --filter "ComplianceState eq 'NonCompliant'" --query "[].{Resource:resourceId, Policy:policyDefinitionName, Reason:complianceReasonCode}"
```

## Best Practices for Enterprise Production

1. **Security First**: Always enable managed identities and avoid storing secrets
2. **Cost Control**: Implement comprehensive budget alerts and regular reviews
3. **Compliance**: Use policy-driven governance and regular compliance checks
4. **Monitoring**: Deploy comprehensive monitoring from day one
5. **Documentation**: Maintain up-to-date runbooks and architecture docs

## Step 4: Managing Multiple Landing Zones

As your organization grows, you'll need to manage multiple landing zones efficiently. Here's a scalable approach:

### Using Terraform Workspaces

```bash
# Create different workspaces for different environments
terraform workspace new development
terraform workspace new staging  
terraform workspace new production

# Deploy to specific environment
terraform workspace select development
terraform apply -var-file="environments/dev.tfvars"
```

### Using a Landing Zone Factory Pattern

Create a "factory" module that can deploy landing zones with different configurations:

```terraform
# landing-zone-factory/main.tf
module "landing_zones" {
  source = "./modules/landing-zone"
  
  for_each = var.landing_zones
  
  application_name = each.key
  configuration    = each.value
}
```

This approach allows you to define multiple landing zones in a single configuration and deploy them consistently.

## Next Steps

In the final module, you'll learn how to integrate AVM resource modules into your vended landing zones to create complete application environments.

---

**Next Module**: [Module 5: End-to-End Implementation](05-end-to-end-implementation.md)
