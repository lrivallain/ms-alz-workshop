# terraform/shared/locals.tf
locals {
  # Naming conventions
  resource_prefix = "${var.project_name}-${var.environment}"

  # Generate unique suffix for globally unique resources
  unique_suffix = random_string.unique.result

  # Common tags merged with user-provided tags
  common_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    #CreatedDate  = formatdate("YYYY-MM-DD", timestamp())
    #LastModified = formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())
    SecurityControl = var.environment == "prod" ? "High" : (var.environment == "dev" ? "Ignore" : "Medium")
  })

  # Environment-specific configurations
  environment_config = {
    is_production  = var.environment == "prod"
    is_development = var.environment == "dev"

    # Features enabled by environment
    features = {
      always_on_webapp     = var.environment != "dev"
      geo_redundant_backup = var.environment == "prod"
      advanced_monitoring  = var.environment == "prod"
    }

    # Security settings
    security = {
      min_tls_version       = "1.2"
      https_only            = true
      storage_public_access = false
    }
  }
}

# Generate unique identifiers
resource "random_string" "unique" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "sql_admin_password" {
  length  = 24
  special = true

  # Ensure password meets Azure SQL requirements
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}