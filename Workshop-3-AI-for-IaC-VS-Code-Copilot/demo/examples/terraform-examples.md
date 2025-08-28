# Example Terraform Configurations

This directory contains reference implementations and examples for common Azure infrastructure patterns, optimized for AI-assisted development.

## Directory Structure

```
examples/
├── basic-patterns/           # Fundamental infrastructure patterns
├── multi-tier/              # Multi-tier application architectures  
├── security-focused/        # Security-first configurations
├── compliance/              # Compliance-ready templates
└── optimization/            # Performance and cost optimization examples
```

## Usage Guidelines

### For AI-Assisted Development
These examples serve as:
- **Context providers**: Use as reference when prompting AI
- **Pattern templates**: Extend and modify for specific requirements  
- **Validation baselines**: Compare AI-generated code against proven patterns
- **Learning accelerators**: Study patterns to improve prompting effectiveness

### Integration with AI Tools
- Copy relevant examples into your workspace for AI context
- Reference patterns in your prompts for better suggestions
- Use examples to validate and improve AI-generated configurations
- Combine patterns to create complex architectures

---

## Basic Patterns

### Resource Group with Tagging
```terraform
# basic-patterns/resource-group.tf
# Standard resource group with comprehensive tagging strategy

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# Resource naming convention
locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Environment   = var.environment
    Project       = var.project_name
    ManagedBy     = "Terraform"
    Owner         = var.owner
    CostCenter    = var.cost_center
    CreatedDate   = timestamp()
  }
}

# Primary resource group
resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location

  tags = local.common_tags
}

# Variables
variable "project_name" {
  description = "Name of the project"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,20}[a-z0-9]$", var.project_name))
    error_message = "Project name must be lowercase, 4-22 characters, start with letter, contain only letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "owner" {
  description = "Resource owner email"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
}

# Outputs
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.main.location
}

output "resource_prefix" {
  description = "Standard prefix for resource naming"
  value       = local.resource_prefix
}
```

### Virtual Network with Subnets
```terraform
# basic-patterns/networking.tf
# Standard virtual network configuration with security

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.resource_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = local.common_tags
}

# Subnets
resource "azurerm_subnet" "web" {
  name                 = "${local.resource_prefix}-web-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.web_subnet_address_space]

  # Delegate to App Service if needed
  dynamic "delegation" {
    for_each = var.enable_app_service_delegation ? [1] : []
    content {
      name = "appservice"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_subnet" "app" {
  name                 = "${local.resource_prefix}-app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.app_subnet_address_space]
}

resource "azurerm_subnet" "data" {
  name                 = "${local.resource_prefix}-data-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.data_subnet_address_space]

  # Enable service endpoints for data services
  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Network Security Groups
resource "azurerm_network_security_group" "web" {
  name                = "${local.resource_prefix}-web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # HTTP/HTTPS inbound
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_network_security_group" "app" {
  name                = "${local.resource_prefix}-app-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Only allow traffic from web subnet
  security_rule {
    name                       = "AllowWebTier"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.web_subnet_address_space
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_network_security_group" "data" {
  name                = "${local.resource_prefix}-data-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # Only allow traffic from app subnet
  security_rule {
    name                       = "AllowAppTier"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = var.app_subnet_address_space
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}

# Variables
variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_address_space" {
  description = "Address space for web subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_address_space" {
  description = "Address space for app subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "data_subnet_address_space" {
  description = "Address space for data subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "enable_app_service_delegation" {
  description = "Enable subnet delegation for App Service"
  type        = bool
  default     = false
}

# Outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value = {
    web  = azurerm_subnet.web.id
    app  = azurerm_subnet.app.id
    data = azurerm_subnet.data.id
  }
}
```

---

## Multi-Tier Application Architecture

### Three-Tier Web Application
```terraform
# multi-tier/web-application.tf
# Complete three-tier web application with App Service, SQL Database, and Redis Cache

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${local.resource_prefix}-asp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"
  sku_name = var.app_service_sku

  tags = local.common_tags
}

# Web Application
resource "azurerm_linux_web_app" "web" {
  name                = "${local.resource_prefix}-webapp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    # Enable health check
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 2

    # Configure for high availability
    always_on = var.environment == "prod" ? true : false

    # Enable Application Insights
    application_stack {
      node_version = "18-lts"
    }

    # CORS configuration
    cors {
      allowed_origins = var.allowed_origins
    }

    # Security headers
    app_command_line = "pm2 start ecosystem.config.js --no-daemon"
  }

  # App settings
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.main.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string
    "DATABASE_URL"                          = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=database-connection-string)"
    "REDIS_CONNECTION_STRING"               = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.main.name};SecretName=redis-connection-string)"
    "NODE_ENV"                              = var.environment
  }

  # Enable system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Enable HTTPS only
  https_only = true

  tags = local.common_tags
}

# SQL Database
resource "azurerm_mssql_server" "main" {
  name                         = "${local.resource_prefix}-sql"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  # Security configuration
  minimum_tls_version = "1.2"

  # Azure AD authentication
  azuread_administrator {
    login_username = var.sql_aad_admin_login
    object_id      = var.sql_aad_admin_object_id
  }

  tags = local.common_tags
}

resource "azurerm_mssql_database" "main" {
  name           = "${local.resource_prefix}-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = var.database_sku
  zone_redundant = var.environment == "prod" ? true : false

  # Enable threat detection
  threat_detection_policy {
    state                      = "Enabled"
    email_account_admins       = "Enabled"
    email_addresses            = [var.security_contact_email]
    retention_days             = 30
    storage_account_access_key = azurerm_storage_account.security.primary_access_key
    storage_endpoint           = azurerm_storage_account.security.primary_blob_endpoint
  }

  tags = local.common_tags
}

# SQL Server firewall rules
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Redis Cache
resource "azurerm_redis_cache" "main" {
  name                = "${local.resource_prefix}-redis"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name

  # Security configuration
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  # Redis configuration
  redis_configuration {
    enable_authentication = true
  }

  tags = local.common_tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "${local.resource_prefix}-appinsights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"

  tags = local.common_tags
}

# Storage Account for security logs
resource "azurerm_storage_account" "security" {
  name                     = "${replace(local.resource_prefix, "-", "")}security"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Security configuration
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  https_traffic_only_enabled      = true

  tags = local.common_tags
}

# Key Vault for secrets
resource "azurerm_key_vault" "main" {
  name                = "${local.resource_prefix}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Security configuration
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.environment == "prod" ? true : false

  tags = local.common_tags
}

# Key Vault access policy for App Service
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.web.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# Store database connection string in Key Vault
resource "azurerm_key_vault_secret" "database_connection" {
  name         = "database-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.main.name};Authentication=Active Directory Managed Identity;"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.app_service]
}

# Store Redis connection string in Key Vault
resource "azurerm_key_vault_secret" "redis_connection" {
  name         = "redis-connection-string"
  value        = "${azurerm_redis_cache.main.hostname}:6380,password=${azurerm_redis_cache.main.primary_access_key},ssl=True,abortConnect=False"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_key_vault_access_policy.app_service]
}

# Data source for current Azure client configuration
data "azurerm_client_config" "current" {}

# Variables
variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "B2"
  validation {
    condition     = contains(["B1", "B2", "B3", "S1", "S2", "S3", "P1v2", "P2v2", "P3v2"], var.app_service_sku)
    error_message = "App Service SKU must be a valid SKU."
  }
}

variable "database_sku" {
  description = "SKU for SQL Database"
  type        = string
  default     = "S2"
}

variable "redis_capacity" {
  description = "Redis cache capacity"
  type        = number
  default     = 1
}

variable "redis_family" {
  description = "Redis cache family"
  type        = string
  default     = "C"
}

variable "redis_sku_name" {
  description = "Redis cache SKU"
  type        = string
  default     = "Standard"
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "sql_aad_admin_login" {
  description = "Azure AD admin login for SQL Server"
  type        = string
}

variable "sql_aad_admin_object_id" {
  description = "Azure AD admin object ID for SQL Server"
  type        = string
}

variable "security_contact_email" {
  description = "Email address for security notifications"
  type        = string
}

variable "allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

# Outputs
output "web_app_url" {
  description = "URL of the web application"
  value       = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "database_server_fqdn" {
  description = "Fully qualified domain name of the database server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
  sensitive   = true
}

output "redis_hostname" {
  description = "Redis cache hostname"
  value       = azurerm_redis_cache.main.hostname
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}
```

---

## AI-Assisted Development Tips

### Using Examples with AI Prompts

#### Context-Rich Prompting
```
Chat Prompt: "Based on the three-tier web application example in my workspace, 
modify the configuration to:
1. Add API Management in front of the web app
2. Include Azure Front Door for global load balancing  
3. Add Container Registry for custom container deployment
4. Implement backup strategies for database and Redis

Maintain the same security standards and naming conventions."
```

#### Pattern Extension Prompting
```terraform
// Extend the basic networking pattern to include:
// - VPN Gateway for hybrid connectivity
// - Azure Firewall for network security
// - Private DNS zones for name resolution  
// - Network Watcher for monitoring
// - DDoS protection for public IPs
//
// Use the existing networking.tf as the foundation
```

#### Validation Prompting
```
Chat Prompt: "Review my Terraform configuration against the reference examples:
1. Are all security best practices implemented?
2. Is the naming convention consistent?
3. Are required tags applied to all resources?
4. Is the network segmentation appropriate?
5. Are there any missing monitoring components?

Provide specific recommendations for improvement."
```

### Best Practices for Example Usage

1. **Start with Foundation**: Use basic patterns as starting points for AI generation
2. **Provide Context**: Include relevant examples in your workspace when prompting
3. **Iterative Refinement**: Use examples to validate and improve AI suggestions
4. **Pattern Recognition**: Help AI understand your organization's standards through examples
5. **Security Validation**: Compare AI-generated code against security-focused examples

---

**Next**: Explore specific pattern directories for detailed implementations and AI prompting strategies.
