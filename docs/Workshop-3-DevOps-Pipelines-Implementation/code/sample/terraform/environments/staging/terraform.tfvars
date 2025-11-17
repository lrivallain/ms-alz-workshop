# terraform/environments/staging/terraform.tfvars
project_name = "webapp"
environment  = "staging"
location     = "East US 2"

# App Service Configuration
app_service_sku = "B1"

# Database Configuration
database_sku                   = "GP_S_Gen5_1"
database_max_size_gb           = 2
database_backup_retention_days = 7
database_geo_redundant_backup  = false

# Storage Configuration
storage_replication_type    = "ZRS"
storage_blob_retention_days = 7

# Monitoring Configuration
log_retention_days = 60

# Tags
tags = {
  Project     = "WebAppDemo"
  Environment = "Staging"
  Owner       = "DevTeam"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
}