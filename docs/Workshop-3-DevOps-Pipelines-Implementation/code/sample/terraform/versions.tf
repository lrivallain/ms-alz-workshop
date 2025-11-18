# terraform/versions.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  # backend "azurerm" {
  #   use_azuread_auth = true
  # }
}

provider "azurerm" {
  subscription_id = "<YOUR_AZURE_SUBSCRIPTION_ID>"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  storage_use_azuread = true
}