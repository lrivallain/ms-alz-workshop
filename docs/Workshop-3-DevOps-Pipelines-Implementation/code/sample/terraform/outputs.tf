# terraform/outputs.tf
# Infrastructure Information
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
}

# Storage Account Information
output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage_account_main.name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = module.storage_account_main.resource.primary_blob_endpoint
  sensitive   = true
}

output "storage_account_connection_string" {
  description = "Connection string for the storage account"
  value       = module.storage_account_main.resource.primary_connection_string
  sensitive   = true
}

# Web Application Information
output "web_app_name" {
  description = "Name of the web application"
  value       = azurerm_linux_web_app.main.name
}

output "web_app_url" {
  description = "URL of the web application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "web_app_identity_principal_id" {
  description = "Principal ID of the web app's managed identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}

# Database Information
output "sql_server_name" {
  description = "Name of the SQL server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Name of the SQL database"
  value       = azurerm_mssql_database.main.name
}

output "sql_connection_string" {
  description = "SQL database connection string"
  value       = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.main.name};User ID=${var.admin_username};Encrypt=True;TrustServerCertificate=False;"
  sensitive   = true
}

# Monitoring Information
output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

# Security Information
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

# Configuration Summary
output "deployment_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    project_name = var.project_name
    environment  = var.environment
    location     = var.location

    resources = {
      resource_group  = azurerm_resource_group.main.name
      web_app         = azurerm_linux_web_app.main.name
      sql_server      = azurerm_mssql_server.main.name
      storage_account = module.storage_account_main.name
      key_vault       = azurerm_key_vault.main.name
    }

    endpoints = {
      web_app_url = "https://${azurerm_linux_web_app.main.default_hostname}"
      storage_url = module.storage_account_main.resource.primary_blob_endpoint
    }

    unique_suffix = local.unique_suffix
    tags          = local.common_tags
  }

  sensitive = true
}