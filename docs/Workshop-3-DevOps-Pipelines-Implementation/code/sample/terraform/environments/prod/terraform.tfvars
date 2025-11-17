# terraform/environments/prod/terraform.tfvars
project_name = "webapp"
environment  = "prod"
location     = "East US 2"

# App Service Configuration
app_service_sku = "B1"

# Database Configuration
database_sku                   = "GP_S_Gen5_1"
database_max_size_gb           = 2
database_backup_retention_days = 7
database_geo_redundant_backup  = false

# Storage Configuration
storage_replication_type    = "GRS"
storage_blob_retention_days = 7

# Monitoring Configuration
log_retention_days = 90

# Tags
tags = {
  Project     = "WebAppDemo"
  Environment = "Production"
  Owner       = "DevTeam"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
  Criticality = "High"
}