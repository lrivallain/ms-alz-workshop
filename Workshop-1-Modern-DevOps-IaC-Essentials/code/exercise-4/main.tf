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

provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  resource_name_prefix = "${var.project_name}-${var.environment}"
  storage_account_name = "st${var.project_name}${var.environment}${random_id.suffix.hex}"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_name_prefix}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_service_plan" "main" {
  name                = "plan-${local.resource_name_prefix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_linux_web_app" "main" {
  name                = "app-${local.resource_name_prefix}-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {}
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
