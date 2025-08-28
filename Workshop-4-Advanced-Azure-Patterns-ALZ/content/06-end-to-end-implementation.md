# Module 5: End-to-End ALZ Implementation

## Learning Objectives
After completing this module, you will be able to:
- Assemble a complete ALZ implementation combining all previous modules
- Deploy application resources using AVM modules in vended landing zones
- Implement monitoring, security, and governance across the entire stack
- Create a repeatable deployment pipeline for enterprise ALZ

## Prerequisites
- Completion of all previous modules (1 through 4)
- Understanding of the relationship between platform and application landing zones
- Basic knowledge of CI/CD concepts

## Architecture Overview

In this module, we'll bring everything together to create a complete, production-ready Azure Landing Zone implementation.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Complete ALZ Architecture                    │
└─────────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Phase 1: Platform Foundation (Modules 2 or 3)                 │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────────┐ │
│ │   Management│ │Connectivity │ │       Management           │ │
│ │   Groups &  │ │    Hub      │ │       Platform            │ │
│ │   Policies  │ │   Network   │ │    (Logging/Automation)    │ │
│ └─────────────┘ └─────────────┘ └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Phase 2: Landing Zone Vending (Module 4)                     │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────────┐ │
│ │ Development │ │   Staging   │ │        Production          │ │
│ │Landing Zone │ │Landing Zone │ │      Landing Zone          │ │
│ └─────────────┘ └─────────────┘ └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Phase 3: Application Resources (AVM Modules)                  │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────────┐ │
│ │ Key Vault & │ │App Services │ │    Databases &             │ │
│ │ Security    │ │& Compute    │ │      Storage               │ │
│ └─────────────┘ └─────────────┘ └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Phase 1: Deploy Platform Foundation

First, let's establish our platform foundation. Choose one approach:

### Option A: Using AVM Pattern Modules (Module 2)

```bash
# Deploy management groups and policies
cd platform/bootstrap
terraform init && terraform apply

# Deploy connectivity
cd ../connectivity  
terraform init && terraform apply

# Deploy management platform
cd ../management
terraform init && terraform apply
```

### Option B: Using ALZ Terraform Accelerator (Module 3)

```bash
# Deploy complete platform using the PowerShell bootstrap
# (Run from the directory created in Module 3)
cd MyALZPlatform
Deploy-Accelerator
```

## Phase 2: Deploy Landing Zones

Deploy landing zones for different environments:

```bash
# Development environment
cd ../landing-zones/development
terraform init && terraform apply

# Staging environment
cd ../staging
terraform init && terraform apply

# Production environment
cd ../production
terraform init && terraform apply
```

## Phase 3: Complete Application Stack

Now let's deploy a complete application stack using AVM resource modules in our vended landing zones.

Create a new directory for the application resources:

```bash
mkdir application-resources
cd application-resources
```

**File: `main.tf`** - Complete application stack
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
    key                  = "applications/ecommerce-prod/terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Get current Azure context
data "azurerm_client_config" "current" {}

# Reference the landing zone outputs
data "terraform_remote_state" "landing_zone" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    key                  = "landing-zones/production/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# Reference platform outputs
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    key                  = "platform/management/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# Generate unique suffix
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Local values for resource configuration
locals {
  # Extract resource group names from landing zone
  rg_security   = data.terraform_remote_state.landing_zone.outputs.resource_groups["security_primary"]["name"]
  rg_data       = data.terraform_remote_state.landing_zone.outputs.resource_groups["data_primary"]["name"]
  rg_compute    = data.terraform_remote_state.landing_zone.outputs.resource_groups["compute_primary"]["name"]
  rg_monitoring = data.terraform_remote_state.landing_zone.outputs.resource_groups["monitoring"]["name"]
  
  # Get subnet IDs from landing zone VNet
  vnet_id = data.terraform_remote_state.landing_zone.outputs.virtual_network_resource_ids["primary"]
  app_subnet_id = "${local.vnet_id}/subnets/snet-app"
  data_subnet_id = "${local.vnet_id}/subnets/snet-data"
  web_subnet_id = "${local.vnet_id}/subnets/snet-web"
  
  # Common tags
  common_tags = {
    Environment   = var.environment
    Application   = var.application_name
    ManagedBy     = "Terraform-AVM"
    CostCenter    = var.cost_center
    Owner         = var.team_email
  }
}

#=============================================================================
# SECURITY TIER - Key Vault and Certificates
#=============================================================================

# Key Vault using AVM
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.9"

  name                = "kv-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_security
  tenant_id          = data.azurerm_client_config.current.tenant_id
  
  # Production-grade configuration
  sku_name                        = "premium"  # Premium for HSM support
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false      # Security best practice
  enabled_for_template_deployment = false      # Security best practice
  enable_rbac_authorization      = true       # Use RBAC instead of access policies
  purge_protection_enabled       = var.environment == "prod"
  soft_delete_retention_days     = var.environment == "prod" ? 90 : 7

  # Network security - restrict to application subnets only
  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [
      local.app_subnet_id,
      local.web_subnet_id
    ]
    ip_rules = var.management_ip_ranges  # Allow management access
  }

  # Role assignments for application identity
  role_assignments = {
    app_secrets_user = {
      role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"
      principal_id       = data.terraform_remote_state.landing_zone.outputs.user_managed_identities["cicd_primary"]["principal_id"]
    }
  }

  # Diagnostic settings to platform Log Analytics
  diagnostic_settings = {
    to_law = {
      name                           = "to-law"
      workspace_resource_id          = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
      log_analytics_destination_type = "Dedicated"
      
      log_categories = [
        "AuditEvent",
        "AzurePolicyEvaluationDetails"
      ]
      
      metric_categories = ["AllMetrics"]
    }
  }

  tags = local.common_tags
}

# Store application secrets
resource "azurerm_key_vault_secret" "database_connection" {
  name         = "database-connection-string"
  value        = "@Microsoft.KeyVault(SecretUri=${module.sql_database.connection_string_secret_uri})"
  key_vault_id = module.key_vault.resource_id
  content_type = "connection-string"
  
  tags = merge(local.common_tags, {
    SecretType = "ConnectionString"
  })
}

#=============================================================================
# DATA TIER - SQL Database and Storage
#=============================================================================

# SQL Server using AVM
module "sql_server" {
  source  = "Azure/avm-res-sql-server/azurerm"
  version = "~> 0.3"

  name                = "sql-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_data
  
  # Security configuration
  administrator_login          = var.sql_admin_username
  administrator_login_password = random_password.sql_admin.result
  
  # Network security
  public_network_access_enabled = false  # Private endpoints only
  
  # Enable Advanced Threat Protection
  threat_detection_policy = {
    enabled                = true
    email_account_admins   = true
    email_addresses        = [var.security_email]
    retention_days         = 30
    storage_account_access_key = module.storage_account.primary_access_key
    storage_endpoint       = module.storage_account.primary_blob_endpoint
  }

  # Azure AD authentication
  azuread_administrator = {
    login_username = var.sql_azuread_admin_name
    object_id      = var.sql_azuread_admin_object_id
  }

  tags = local.common_tags
}

# SQL Database
module "sql_database" {
  source  = "Azure/avm-res-sql-database/azurerm" 
  version = "~> 0.2"

  name      = "${var.application_name}-db"
  server_id = module.sql_server.resource_id
  
  # Production sizing
  sku_name = var.environment == "prod" ? "S2" : "S0"  # Standard tier
  
  # Backup and recovery
  backup_storage_redundancy = var.environment == "prod" ? "GeoRedundant" : "LocalRedundant"
  
  # Security
  transparent_data_encryption_enabled = true
  
  # Monitoring
  extended_auditing_policy = {
    storage_endpoint                        = module.storage_account.primary_blob_endpoint
    storage_account_access_key             = module.storage_account.primary_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                      = 90
  }

  tags = local.common_tags
}

# Generate secure password for SQL admin
resource "random_password" "sql_admin" {
  length  = 20
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Storage Account using AVM
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.2"

  name                = "st${var.application_name}${var.environment}${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_data
  
  # Performance and redundancy
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  account_kind            = "StorageV2"
  
  # Security configuration
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false  # Use managed identities only
  min_tls_version                = "TLS1_2"
  
  # Network security
  network_rules = {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    virtual_network_subnet_ids = [
      local.app_subnet_id,
      local.web_subnet_id
    ]
    ip_rules = var.management_ip_ranges
  }

  # Containers for application data
  containers = {
    app-data = {
      name                  = "app-data"
      container_access_type = "private"
    }
    backups = {
      name                  = "backups"
      container_access_type = "private"
    }
    logs = {
      name                  = "logs"
      container_access_type = "private"
    }
  }

  # Role assignments for application identity  
  role_assignments = {
    app_blob_contributor = {
      role_definition_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe"
      principal_id       = data.terraform_remote_state.landing_zone.outputs.user_managed_identities["cicd_primary"]["principal_id"]
    }
  }

  # Diagnostic settings
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
      
      log_categories = [
        "StorageRead",
        "StorageWrite", 
        "StorageDelete"
      ]
      metric_categories = ["AllMetrics"]
    }
  }

  tags = local.common_tags
}

#=============================================================================
# COMPUTE TIER - App Services and Web Apps
#=============================================================================

# App Service Plan using AVM
module "app_service_plan" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "~> 0.2"

  name                = "asp-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_compute
  
  # Sizing based on environment
  sku = {
    tier = var.environment == "prod" ? "Premium" : "Standard"
    size = var.environment == "prod" ? "P1" : "S1"
  }
  
  # High availability for production
  zone_balancing_enabled = var.environment == "prod"
  
  tags = local.common_tags
}

# Web App using AVM
module "web_app" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "~> 0.2"

  name                = "app-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_compute
  service_plan_id     = module.app_service_plan.resource_id
  
  # Runtime configuration
  site_config = {
    always_on        = var.environment == "prod"
    http2_enabled    = true
    min_tls_version  = "1.2"
    
    # Application stack
    application_stack = {
      dotnet_version = "8.0"
    }
    
    # Security headers
    cors = {
      allowed_origins = var.allowed_origins
      support_credentials = false
    }
  }

  # Network integration
  virtual_network_subnet_id = local.app_subnet_id

  # Application settings
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "KeyVault__Endpoint"       = module.key_vault.vault_uri
    "Storage__ConnectionString" = "@Microsoft.KeyVault(SecretUri=${module.key_vault.resource_id}/secrets/storage-connection)"
    "Database__ConnectionString" = "@Microsoft.KeyVault(SecretUri=${module.key_vault.resource_id}/secrets/database-connection-string)"
  }

  # System-assigned managed identity
  identity = {
    type = "SystemAssigned"
  }

  # Diagnostic settings
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
      
      log_categories = [
        "AppServiceHTTPLogs",
        "AppServiceConsoleLogs",
        "AppServiceAppLogs",
        "AppServiceAuditLogs"
      ]
      metric_categories = ["AllMetrics"]
    }
  }

  tags = local.common_tags
}

#=============================================================================
# MONITORING TIER - Application Insights and Monitoring
#=============================================================================

# Application Insights using AVM
module "application_insights" {
  source  = "Azure/avm-res-insights-component/azurerm"
  version = "~> 0.1"

  name                = "appi-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_monitoring
  
  application_type      = "web"
  workspace_resource_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
  
  # Data retention
  retention_in_days   = var.environment == "prod" ? 730 : 90
  sampling_percentage = var.environment == "prod" ? 100 : 10
  
  # Privacy settings
  disable_ip_masking = false
  
  tags = local.common_tags
}

# Log Analytics Workspace for application-specific logs
module "app_log_analytics" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.3"

  name                = "law-${var.application_name}-${var.environment}-${random_string.suffix.result}"
  location            = var.primary_location
  resource_group_name = local.rg_monitoring
  
  # Configuration
  retention_in_days                    = var.environment == "prod" ? 365 : 90
  daily_quota_gb                      = var.environment == "prod" ? 50 : 5
  internet_ingestion_enabled         = false
  internet_query_enabled             = false
  reservation_capacity_in_gb_per_day = var.environment == "prod" ? 100 : null
  sku                               = "PerGB2018"

  tags = local.common_tags
}

#=============================================================================
# MONITORING AND ALERTING
#=============================================================================

# Action Group for alerts
resource "azurerm_monitor_action_group" "app_alerts" {
  name                = "ag-${var.application_name}-${var.environment}"
  resource_group_name = local.rg_monitoring
  short_name          = substr("${var.application_name}${var.environment}", 0, 12)

  # Email notifications
  dynamic "email_receiver" {
    for_each = var.alert_email_contacts
    content {
      name          = "email-${email_receiver.key}"
      email_address = email_receiver.value
    }
  }

  # SMS notifications for critical production alerts
  dynamic "sms_receiver" {
    for_each = var.environment == "prod" ? var.alert_sms_contacts : {}
    content {
      name         = "sms-${sms_receiver.key}"
      country_code = "1"
      phone_number = sms_receiver.value
    }
  }

  tags = local.common_tags
}

# Application performance alerts
resource "azurerm_monitor_metric_alert" "high_response_time" {
  name                = "High Response Time - ${var.application_name}"
  resource_group_name = local.rg_monitoring
  scopes              = [module.web_app.resource_id]
  description         = "Alert when average response time exceeds threshold"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 2 : 5  # seconds
  }

  action {
    action_group_id = azurerm_monitor_action_group.app_alerts.id
  }

  frequency   = "PT1M"
  window_size = "PT5M"
  severity    = var.environment == "prod" ? 1 : 2

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "High Error Rate - ${var.application_name}"
  resource_group_name = local.rg_monitoring
  scopes              = [module.web_app.resource_id]
  description         = "Alert when HTTP 5xx error rate exceeds threshold"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 10 : 50
  }

  action {
    action_group_id = azurerm_monitor_action_group.app_alerts.id
  }

  frequency   = "PT1M"
  window_size = "PT5M"
  severity    = var.environment == "prod" ? 0 : 1  # Critical for prod

  tags = local.common_tags
}

# Database performance alert
resource "azurerm_monitor_metric_alert" "high_database_cpu" {
  name                = "High Database CPU - ${var.application_name}"
  resource_group_name = local.rg_monitoring
  scopes              = [module.sql_database.resource_id]
  description         = "Alert when database CPU usage exceeds threshold"

  criteria {
    metric_namespace = "Microsoft.Sql/servers/databases"
    metric_name      = "cpu_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.environment == "prod" ? 80 : 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.app_alerts.id
  }

  frequency   = "PT1M"
  window_size = "PT5M"
  severity    = 2

  tags = local.common_tags
}
```

**File: `variables.tf`**
```terraform
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

variable "primary_location" {
  description = "Primary Azure region"
  type        = string
  default     = "East US"
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
}

variable "team_email" {
  description = "Team email for notifications"
  type        = string
}

variable "security_email" {
  description = "Security team email for security alerts"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  default     = "sqladmin"
}

variable "sql_azuread_admin_name" {
  description = "Azure AD admin name for SQL Server"
  type        = string
}

variable "sql_azuread_admin_object_id" {
  description = "Azure AD admin object ID for SQL Server"
  type        = string
}

variable "management_ip_ranges" {
  description = "IP ranges allowed for management access"
  type        = list(string)
  default     = []
}

variable "allowed_origins" {
  description = "Allowed CORS origins for web app"
  type        = list(string)
  default     = ["https://*.yourdomain.com"]
}

variable "alert_email_contacts" {
  description = "Email contacts for alerts"
  type        = map(string)
  default = {
    primary = "alerts@contoso.com"
  }
}

variable "alert_sms_contacts" {
  description = "SMS contacts for critical production alerts"
  type        = map(string)
  default = {}
}
```

**File: `outputs.tf`**
```terraform
output "application_urls" {
  description = "Application URLs"
  value = {
    web_app_url = "https://${module.web_app.default_hostname}"
    key_vault_uri = module.key_vault.vault_uri
  }
}

output "connection_strings" {
  description = "Application connection strings (sensitive)"
  value = {
    database_connection = module.sql_database.connection_string
    storage_connection  = module.storage_account.primary_connection_string
  }
  sensitive = true
}

output "monitoring_info" {
  description = "Monitoring and observability information"
  value = {
    application_insights_app_id         = module.application_insights.app_id
    application_insights_connection_string = module.application_insights.connection_string
    log_analytics_workspace_id         = module.app_log_analytics.resource_id
  }
  sensitive = true
}

output "resource_ids" {
  description = "Resource IDs for reference"
  value = {
    key_vault_id       = module.key_vault.resource_id
    sql_server_id      = module.sql_server.resource_id
    sql_database_id    = module.sql_database.resource_id
    storage_account_id = module.storage_account.resource_id
    web_app_id         = module.web_app.resource_id
    app_service_plan_id = module.app_service_plan.resource_id
  }
}
```

## Deployment Pipeline

Create a complete deployment pipeline that orchestrates all phases:

**File: `deploy.sh`**
```bash
#!/bin/bash
set -e

echo "🚀 Starting complete ALZ deployment..."

# Phase 1: Platform Foundation
echo "📋 Phase 1: Deploying Platform Foundation..."
if [ "$PLATFORM_TYPE" = "accelerator" ]; then
    cd alz-accelerator
    terraform init -backend-config="key=alz-accelerator/terraform.tfstate"
    terraform apply -auto-approve
    cd ..
else
    # Deploy with AVM modules
    cd platform/bootstrap
    terraform init -backend-config="key=bootstrap/terraform.tfstate"  
    terraform apply -auto-approve
    cd ../connectivity
    terraform init -backend-config="key=platform/connectivity/terraform.tfstate"
    terraform apply -auto-approve
    cd ../management
    terraform init -backend-config="key=platform/management/terraform.tfstate"
    terraform apply -auto-approve
    cd ../..
fi

# Phase 2: Landing Zones
echo "🏗️  Phase 2: Deploying Landing Zones..."
environments=("development" "staging" "production")
for env in "${environments[@]}"; do
    echo "Deploying $env landing zone..."
    cd landing-zones/$env
    terraform init -backend-config="key=landing-zones/$env/terraform.tfstate"
    terraform apply -auto-approve -var="environment=$env"
    cd ../..
done

# Phase 3: Application Resources  
echo "🔧 Phase 3: Deploying Application Resources..."
cd application-resources
terraform init -backend-config="key=applications/ecommerce-prod/terraform.tfstate"
terraform apply -auto-approve

echo "✅ Complete ALZ deployment finished successfully!"

# Note: The following command requires 'jq' to be installed to parse the JSON output.
# If you do not have jq, you can run 'terraform output application_urls' to see the full output.
echo "🌐 Application URL: $(terraform output -json application_urls | jq -r .web_app_url)"
```

## Validation and Testing

### Infrastructure Validation

```bash
# Validate management group structure
az account management-group list --query "[].{Name:displayName, ID:name}" -o table

# Check policy compliance
az policy state list --management-group "alz-corp" --query "[?complianceState=='NonCompliant'].{Resource:resourceId, Policy:policyDefinitionName}" -o table

# Verify network connectivity
az network vnet peering list --resource-group "rg-connectivity-hub" --vnet-name "hub-vnet" --query "[].{Name:name, State:peeringState}" -o table

# Check application health
az webapp show --name "app-ecommerce-prod-abc123" --resource-group "rg-ecommerce-prod-compute" --query "{Name:name, State:state, URL:defaultHostName}" -o table
```

### Application Testing

```bash
# Test application endpoints
curl -I https://app-ecommerce-prod-abc123.azurewebsites.net/health

# Check database connectivity
az sql db show-connection-string --server "sql-ecommerce-prod-abc123" --name "ecommerce-db" --client "ado.net"

# Verify Key Vault access
az keyvault secret list --vault-name "kv-ecommerce-prod-abc123" --query "[].name" -o tsv
```

### Monitoring Validation

```bash
# Check Application Insights telemetry
az monitor app-insights query --app "appi-ecommerce-prod-abc123" --analytics-query "requests | take 10"

# Review alert rules
az monitor metrics alert list --resource-group "rg-ecommerce-prod-monitoring" --query "[].{Name:name, Enabled:enabled, Severity:severity}" -o table

# Check log ingestion
az monitor log-analytics query --workspace "law-ecommerce-prod-abc123" --analytics-query "Heartbeat | take 5"
```

## Best Practices Summary

### 1. State Management
- ✅ Separate state files by layer and environment
- ✅ Use Azure Storage backend with Azure AD authentication
- ✅ Lock state files in production environments

### 2. Security
- ✅ Enable private endpoints for PaaS services
- ✅ Use managed identities instead of connection strings
- ✅ Implement network segmentation with NSGs
- ✅ Enable diagnostic logging for all resources

### 3. Monitoring
- ✅ Deploy comprehensive alerting for all tiers
- ✅ Use Application Insights for application telemetry
- ✅ Centralize logging in platform Log Analytics workspace
- ✅ Implement budget alerts and cost management

### 4. Governance
- ✅ Apply consistent tagging across all resources
- ✅ Use policy-driven compliance
- ✅ Implement RBAC with principle of least privilege
- ✅ Regular compliance and security reviews

### 5. Scalability
- ✅ Design for multiple environments and regions
- ✅ Use infrastructure as code for all deployments
- ✅ Implement CI/CD pipelines for consistent deployments
- ✅ Plan for disaster recovery and business continuity

## Troubleshooting Common Issues

### Policy Conflicts
```bash
# Check for policy conflicts
az policy state list --filter "ComplianceState eq 'NonCompliant'" --query "[].{Resource:resourceId, Policy:policyDefinitionName, Reason:complianceReasonCode}"
```

### Network Connectivity Issues
```bash
# Check effective routes
az network nic show-effective-route-table --name "vm-nic" --resource-group "rg-compute"

# Verify NSG rules
az network nsg rule list --nsg-name "nsg-app" --resource-group "rg-network" --query "[].{Name:name, Priority:priority, Access:access}"
```

### Application Performance Issues
```bash
# Check App Service metrics
az monitor metrics list --resource "/subscriptions/.../providers/Microsoft.Web/sites/app-name" --metric "ResponseTime,Requests" --start-time "2024-01-01T00:00:00Z"
```

## Next Steps and Advanced Topics

This completes our comprehensive ALZ implementation! For advanced scenarios, consider exploring:

1. **Multi-region deployments** with global load balancing
2. **Advanced security patterns** with Azure Security Center and Sentinel
3. **DevOps integration** with GitHub Actions and Azure DevOps
4. **Cost optimization** with Azure Cost Management and budgets
5. **Compliance frameworks** (SOC 2, ISO 27001, PCI DSS)

## Conclusion

You've successfully implemented a complete, enterprise-grade Azure Landing Zone using Terraform and Azure Verified Modules. This implementation provides:

- ✅ **Scalable platform foundation** with proper governance
- ✅ **Automated landing zone vending** for consistent workload environments  
- ✅ **Complete application stack** using AVM best practices
- ✅ **Comprehensive monitoring and alerting**
- ✅ **Enterprise security and compliance**

Your organization now has a solid foundation for cloud adoption at scale!

---

**Workshop Complete!** 🎉
