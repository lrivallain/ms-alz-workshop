variable "name" {
  description = "Database name prefix"
  type        = string
}

variable "resource_group_name" {
  description = "Target resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_username" {
  description = "SQL admin username"
  type        = string
}

variable "database_sku" {
  description = "Database SKU"
  type        = string
  default     = "Basic"
}

variable "server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
