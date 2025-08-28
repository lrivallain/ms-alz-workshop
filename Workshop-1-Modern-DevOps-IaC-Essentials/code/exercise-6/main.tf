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

resource "azurerm_resource_group" "main" {
  name     = "rg-workshop-db-exercise"
  location = "East US"
}

module "database_dev" {
  source = "./modules/database"

  name                = "wshp-dev"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  admin_username      = "sqladmin"
  database_sku        = "Basic"

  tags = {
    Environment = "Development"
  }
}

module "database_prod" {
  source = "./modules/database"

  name                = "wshp-prod"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  admin_username      = "sqladmin"
  database_sku        = "S0" # Standard SKU

  tags = {
    Environment = "Production"
  }
}

output "dev_db_connection_string" {
  description = "Connection string for the dev database."
  value       = module.database_dev.connection_string
  sensitive   = true
}

output "prod_db_connection_string" {
  description = "Connection string for the prod database."
  value       = module.database_prod.connection_string
  sensitive   = true
}
