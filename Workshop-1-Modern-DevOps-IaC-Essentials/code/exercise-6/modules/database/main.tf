terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_mssql_server" "main" {
  name                         = "sql-${var.name}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.server_version
  administrator_login          = var.admin_username
  administrator_login_password = random_password.password.result
  tags                         = var.tags
}

resource "azurerm_mssql_database" "main" {
  name      = "sqldb-${var.name}"
  server_id = azurerm_mssql_server.main.id
  sku_name  = var.database_sku
  tags      = var.tags
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
