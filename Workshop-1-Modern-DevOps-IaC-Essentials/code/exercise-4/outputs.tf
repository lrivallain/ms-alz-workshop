output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.main.name
}

output "web_app_url" {
  description = "The URL of the web app."
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}
