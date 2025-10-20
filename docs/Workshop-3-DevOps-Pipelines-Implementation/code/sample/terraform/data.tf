# terraform/shared/data.tf
# Current Azure client configuration
data "azurerm_client_config" "current" {}

# Current Azure subscription
data "azurerm_subscription" "current" {}