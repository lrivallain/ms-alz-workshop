locals {
  # Naming conventions
  resource_prefix = "${var.project_name}-${var.environment}"
  
  # Generate unique suffix for globally unique resources
  unique_suffix = random_string.unique.result
  
  # Common tags merged with user-provided tags
  common_tags = merge(var.tags, {
    Environment   = var.environment
    Project      = var.project_name
    ManagedBy    = "Terraform"
    CreatedDate  = formatdate("YYYY-MM-DD", timestamp())
    LastModified = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
  })
  
  # Environment-specific configurations
  environment_config = {
    is_production = var.environment == "prod"
    is_development = var.environment == "dev"
    
    # Features enabled by environment
    features = {
      always_on_webapp = var.environment != "dev"
      geo_redundant_backup = var.environment == "prod"
      advanced_monitoring = var.environment == "prod"
    }
    
    # Security settings
    security = {
      min_tls_version = "1.2"
      https_only = true
      storage_public_access = false
    }
  }
}

# Generate unique identifiers
resource "random_string" "unique" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "sql_admin_password" {
  length  = 24
  special = true
  
  # Ensure password meets Azure SQL requirements
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

# Current Azure client configuration
data "azurerm_client_config" "current" {}

# Current Azure subscription
data "azurerm_subscription" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_prefix}"
  location = var.location
  
  tags = local.common_tags
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                = "st${replace(local.resource_prefix, "-", "")}${local.unique_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  
  account_tier             = "Standard"
  account_replication_type = var.storage_replication_type
  account_kind            = "StorageV2"
  
  # Security settings
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  
  # Infrastructure encryption for production
  infrastructure_encryption_enabled = local.environment_config.is_production
  
  # Blob properties
  blob_properties {
    # Enable versioning
    versioning_enabled = true
    
    # Change feed for audit trail
    change_feed_enabled = local.environment_config.is_production
    
    # Retention policy
    delete_retention_policy {
      days = var.storage_blob_retention_days
    }
    
    # Container retention policy
    container_delete_retention_policy {
      days = var.storage_blob_retention_days
    }
  }
  
  # Network rules (restrictive by default)
  network_rules {
    default_action = "Deny"
    ip_rules      = [] # Add your IP addresses as needed
    
    # Allow access from the same virtual network (when implemented)
    virtual_network_subnet_ids = []
  }
  
  tags = merge(local.common_tags, {
    Component = "Storage"
    Service   = "DataStorage"
  })
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${local.resource_prefix}"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  sku               = "PerGB2018"
  retention_in_days = var.log_retention_days
  
  # Data export and linked services
  daily_quota_gb = local.environment_config.is_development ? 1 : null
  
  tags = merge(local.common_tags, {
    Component = "Monitoring"
    Service   = "LogAnalytics"
  })
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "appi-${local.resource_prefix}"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id       = azurerm_log_analytics_workspace.main.id
  
  application_type = "web"
  
  # Retention and sampling
  retention_in_days   = var.log_retention_days
  daily_data_cap_in_gb = local.environment_config.is_development ? 1 : null
  
  tags = merge(local.common_tags, {
    Component = "Monitoring"
    Service   = "ApplicationInsights"
  })
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-${local.resource_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  
  os_type  = "Linux"
  sku_name = var.app_service_sku
  
  # Auto-scaling settings for production
  maximum_elastic_worker_count = local.environment_config.is_production ? 10 : null
  worker_count                = local.environment_config.is_production ? 2 : 1
  
  tags = merge(local.common_tags, {
    Component = "Compute"
    Service   = "AppServicePlan"
  })
}

# Web App
resource "azurerm_linux_web_app" "main" {
  name                = "app-${local.resource_prefix}-${local.unique_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_service_plan.main.location
  service_plan_id    = azurerm_service_plan.main.id
  
  # Application configuration
  site_config {
    # Always on for non-development environments
    always_on = local.environment_config.features.always_on_webapp
    
    # Runtime configuration
    application_stack {
      node_version = "18-lts"
    }
    
    # Security settings
    http2_enabled                    = true
    minimum_tls_version             = local.environment_config.security.min_tls_version
    scm_minimum_tls_version         = local.environment_config.security.min_tls_version
    ftps_state                      = "FtpsOnly"
    
    # Health check
    health_check_path                = "/health"
    health_check_eviction_time_in_min = 2
    
    # CORS settings (configure as needed)
    cors {
      allowed_origins     = ["*"] # Restrict in production
      support_credentials = false
    }
  }
  
  # HTTPS configuration
  https_only = local.environment_config.security.https_only
  
  # Application settings
  app_settings = {
    # Runtime environment
    NODE_ENV = var.environment == "prod" ? "production" : "development"
    PORT     = "8080"
    
    # Application configuration
    ENVIRONMENT                     = var.environment
    WEBSITE_RUN_FROM_PACKAGE        = "1"
    WEBSITE_ENABLE_SYNC_UPDATE_SITE = "true"
    
    # Storage connection
    STORAGE_CONNECTION_STRING = azurerm_storage_account.main.primary_connection_string
    
    # Application Insights
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.main.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    
    # Database connection (will be added after SQL resources)
    DATABASE_SERVER = azurerm_mssql_server.main.fully_qualified_domain_name
    DATABASE_NAME   = azurerm_mssql_database.main.name
    DATABASE_USERNAME = var.admin_username
    # REMOVED: DATABASE_PASSWORD - This will be fetched by the app from Key Vault
    KEY_VAULT_URI   = azurerm_key_vault.main.vault_uri
  }
  
  # Managed identity for secure access
  identity {
    type = "SystemAssigned"
  }
  
  # Connection strings
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.main.name};User ID=${var.admin_username};Password=${random_password.sql_admin_password.result};Encrypt=True;TrustServerCertificate=False;"
  }
  
  tags = merge(local.common_tags, {
    Component = "Compute"
    Service   = "WebApp"
    Runtime   = "Node.js"
  })
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                = "sql-${local.resource_prefix}-${local.unique_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  
  version                       = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = random_password.sql_admin_password.result
  
  # Security settings
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
  
  # Azure AD authentication (recommended)
  azuread_administrator {
    login_username              = data.azurerm_client_config.current.object_id
    object_id                  = data.azurerm_client_config.current.object_id
    tenant_id                  = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = false # Set to true after setting up Azure AD users
  }
  
  tags = merge(local.common_tags, {
    Component = "Database"
    Service   = "SQLServer"
  })
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name      = "sqldb-${local.resource_prefix}"
  server_id = azurerm_mssql_server.main.id
  
  # SKU configuration
  sku_name = var.database_sku
  
  # Storage configuration
  max_size_gb = var.database_max_size_gb
  
  # Backup configuration
  short_term_retention_policy {
    retention_days = var.database_backup_retention_days
  }
  
  # Maintenance and performance
  auto_pause_delay_in_minutes = local.environment_config.is_development ? 60 : null
  min_capacity               = local.environment_config.is_development ? 0.5 : null
  
  # Threat detection policy
  threat_detection_policy {
    state                  = "Enabled"
    email_account_admins   = true
    email_addresses       = [] # Add admin email addresses
    retention_days        = 30
    storage_account_access_key = azurerm_storage_account.main.primary_access_key
    storage_endpoint      = azurerm_storage_account.main.primary_blob_endpoint
  }
  
  tags = merge(local.common_tags, {
    Component = "Database"
    Service   = "SQLDatabase"
  })
}

# Firewall rule for Azure services (adjust as needed)
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Key Vault for secrets management
resource "azurerm_key_vault" "main" {
  name                = "kv-${local.resource_prefix}-${local.unique_suffix}"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id          = data.azurerm_client_config.current.tenant_id
  
  sku_name = "standard"
  
  # Security settings
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enable_rbac_authorization      = true
  public_network_access_enabled  = false
  
  # Purge protection for production
  purge_protection_enabled = local.environment_config.is_production
  soft_delete_retention_days = local.environment_config.is_production ? 90 : 7
  
  # Network access rules
  network_acls {
    default_action = "Deny"
    bypass        = "AzureServices"
    ip_rules      = [] # Add your IP addresses
  }
  
  tags = merge(local.common_tags, {
    Component = "Security"
    Service   = "KeyVault"
  })
}

# Key Vault access policy for current user/service principal
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  
  key_permissions = [
    "Get", "List", "Create", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
}

# Key Vault access policy for Web App managed identity
resource "azurerm_key_vault_access_policy" "webapp" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = azurerm_linux_web_app.main.identity[0].tenant_id
  object_id    = azurerm_linux_web_app.main.identity[0].principal_id
  
  secret_permissions = [
    "Get", "List"
  ]
}

# Store SQL password in Key Vault
resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [
    azurerm_key_vault_access_policy.current_user
  ]
  
  tags = merge(local.common_tags, {
    Component = "Security"
    Service   = "Secret"
  })
}
