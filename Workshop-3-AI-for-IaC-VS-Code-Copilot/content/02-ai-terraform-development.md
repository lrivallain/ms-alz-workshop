# Session 2: AI-Powered Terraform Development

## Session Overview
**Duration**: 75 minutes  
**Format**: Guided Lab + Live Demonstration  
**Objective**: Master AI-assisted Terraform development for real-world infrastructure scenarios

---

## Learning Objectives

By the end of this session, participants will:
- Generate complete Terraform configurations using AI prompts
- Understand context-aware infrastructure pattern recognition
- Build complex multi-resource Azure infrastructures with AI assistance
- Refactor and optimize existing Terraform code using Copilot
- Implement proper resource dependencies and naming conventions
- Use AI for variable management and output generation

---

## Advanced Copilot Techniques for Terraform

### Prompt Engineering for Infrastructure

**Effective Prompting Strategy**:
1. **Set Context** - Project, environment, compliance requirements
2. **Define Architecture** - Components and relationships
3. **Specify Constraints** - Security, performance, cost considerations
4. **Include Examples** - Reference existing patterns or standards

### Infrastructure Generation Patterns

#### Pattern 1: Layered Architecture Prompts

```terraform
# Layer 1: Foundation Infrastructure
# Create foundational network and security infrastructure for enterprise application
# Requirements: VNet with multiple subnets, NSGs, Key Vault for secrets management
# Security: Private endpoints, no public access, encryption at rest and in transit
# Naming: Follow Azure naming conventions with environment prefix

# [Copilot generates foundation resources]

# Layer 2: Compute and Storage
# Add compute and storage resources to the existing foundation
# Requirements: App Service with managed identity, Storage with hierarchical namespace
# Integration: Connect to existing Key Vault and VNet with private endpoints
# Scaling: Production-ready scaling settings

# [Copilot builds on existing foundation]

# Layer 3: Monitoring and Compliance
# Complete the infrastructure with comprehensive monitoring and compliance
# Requirements: Log Analytics, Application Insights, Policy assignments
# Integration: Connect all resources to centralized monitoring
# Compliance: Enable auditing, diagnostic settings, and alerts

# [Copilot adds monitoring layer]
```

#### Pattern 2: Environment-Aware Generation

```terraform
# Development Environment Configuration
# Purpose: Cost-optimized development environment for web application
# Characteristics: Basic SKUs, limited scalability, relaxed security for development
# Components: Resource Group, App Service (B1), SQL Database (Basic), Storage (LRS)

variable "environment" {
  default = "dev"
}

variable "cost_optimized" {
  default = true
}

# [Copilot generates dev-appropriate configurations]

# Production Environment Configuration  
# Purpose: High-availability production environment
# Characteristics: Premium SKUs, auto-scaling, enhanced security, geo-redundancy
# Components: Same as dev but with production-grade configurations

variable "environment" {
  default = "prod"
}

variable "high_availability" {
  default = true
}

# [Copilot adapts configurations for production requirements]
```

---

## Building Complete Infrastructure with AI

### Scenario: E-Commerce Platform Infrastructure

Let's build a comprehensive e-commerce platform using AI assistance:

```terraform
# E-Commerce Platform Infrastructure
# 
# Architecture Requirements:
# - Frontend: Static web app for React.js application
# - Backend: Container-based API service with auto-scaling
# - Database: PostgreSQL with read replicas for high availability  
# - Storage: Blob storage for product images and user uploads
# - Security: Key Vault, managed identities, private networking
# - Monitoring: Comprehensive observability and alerting
# - CDN: Global content delivery for static assets
# 
# Non-functional Requirements:
# - Support 10,000+ concurrent users
# - 99.9% availability SLA
# - GDPR compliant data handling
# - Cost-optimized for variable traffic patterns
# 
# Environment: Production
# Region: East US (primary), West US (disaster recovery)

# [Start with this comprehensive prompt and let Copilot generate the infrastructure]
```

**Expected AI-Generated Structure**:
```terraform
# Resource Group
resource "azurerm_resource_group" "ecommerce_prod" {
  name     = "rg-ecommerce-prod-eastus"
  location = "East US"
  
  tags = {
    Environment = "Production"
    Project     = "ECommerce"
    ManagedBy   = "Terraform"
  }
}

# Virtual Network and Security
resource "azurerm_virtual_network" "main" {
  name                = "vnet-ecommerce-prod"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ecommerce_prod.location
  resource_group_name = azurerm_resource_group.ecommerce_prod.name

  tags = azurerm_resource_group.ecommerce_prod.tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.ecommerce_prod.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.ecommerce_prod.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
  
  delegation {
    name = "container-apps"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "database" {
  name                 = "snet-database"
  resource_group_name  = azurerm_resource_group.ecommerce_prod.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

# [Continue with Container Apps Environment, Database, Storage, etc.]
```

### AI-Assisted Resource Dependencies

**Technique**: Let Copilot understand and create proper dependencies

```terraform
# Base infrastructure completed above...

# Now add dependent services - Copilot understands the context
# Create PostgreSQL server integrated with existing VNet and security
# Requirements: Private endpoint, connection to Key Vault, backup configured
# Performance: General Purpose, 4 vCores, optimized for OLTP workloads

resource "azurerm_postgresql_flexible_server" "main" {
  # [Copilot generates with proper dependencies and references]
}

# Create container app that connects to the database
# Requirements: Connect to PostgreSQL, use managed identity, scale 2-20 instances
# Configuration: Environment variables from Key Vault, health checks configured
# Integration: Private networking, monitoring enabled

resource "azurerm_container_app" "api" {
  # [Copilot creates with database connection and proper configuration]
}
```

---

## Context-Aware Code Generation

### Understanding File Relationships

Copilot analyzes your entire Terraform project structure:

#### Main Configuration (main.tf)
```terraform
# Core infrastructure resources
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.common_tags
}
```

#### Variables File (variables.tf)
```terraform
# When you start typing in variables.tf, Copilot suggests based on main.tf usage
variable "project_name" {
  description = "Name of the project"
  type        = string
  
  validation {
    # Copilot suggests appropriate validations based on usage patterns
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}
```

#### Outputs File (outputs.tf)
```terraform
# Copilot automatically suggests outputs based on resources in main.tf
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

# Additional suggested outputs based on infrastructure
output "web_app_url" {
  description = "URL of the web application"
  value       = azurerm_linux_web_app.main.default_hostname
  sensitive   = false
}
```

### Module-Aware Generation

When working with Terraform modules, Copilot understands the module structure:

```terraform
# modules/web-app/main.tf
# Copilot recognizes this is a module and suggests appropriate patterns

# modules/web-app/variables.tf
# Copilot suggests variables that match the module's resource requirements

# modules/web-app/outputs.tf
# Copilot suggests outputs that would be useful to parent configurations
```

---

## Advanced AI Techniques

### 1. Multi-Resource Pattern Recognition

**Scenario**: Creating consistent environments across dev/staging/prod

```terraform
# Development environment established first
resource "azurerm_app_service_plan" "dev" {
  name                = "asp-webapp-dev"
  location            = azurerm_resource_group.dev.location
  resource_group_name = azurerm_resource_group.dev.name
  
  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Start creating staging - Copilot recognizes the pattern
resource "azurerm_app_service_plan" "staging" {
  # Copilot suggests similar structure but with staging-appropriate configurations
  name                = "asp-webapp-staging"
  location            = azurerm_resource_group.staging.location
  resource_group_name = azurerm_resource_group.staging.name
  
  sku {
    tier = "Standard"  # Upgraded for staging
    size = "S1"
  }
}
```

### 2. Security-First Generation

**Technique**: Prime Copilot with security requirements

```terraform
# Security-focused infrastructure generation
# Requirements: Zero trust architecture, private networking only, encryption everywhere
# Compliance: SOC 2, ISO 27001, data residency requirements
# Authentication: Managed identities only, no service principal keys

# Create Key Vault with maximum security settings
resource "azurerm_key_vault" "main" {
  # [Copilot generates with security-first configuration]
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  purge_protection_enabled        = true
  
  network_acls {
    default_action = "Deny"
    bypass         = "None"
  }
}

# Create storage account with security hardening
resource "azurerm_storage_account" "secure" {
  # [Copilot continues with security-focused approach]
  public_network_access_enabled   = false
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  
  network_rules {
    default_action = "Deny"
  }
}
```

### 3. Cost-Optimization Patterns

```terraform
# Cost-optimized infrastructure for startup environment
# Budget constraint: $200/month maximum
# Requirements: Auto-scaling down to zero during off-hours
# Performance: Acceptable latency for development and testing workloads

# Copilot will suggest cost-appropriate configurations:
# - Consumption-based pricing where available
# - Basic SKUs for non-critical resources
# - Auto-pause capabilities
# - Shared resources where possible

resource "azurerm_app_service_plan" "startup" {
  # Copilot suggests cost-optimized configuration
}
```

---

## Guided Lab: Building Real Infrastructure

### Lab Setup

Create a new Terraform project:

```bash
mkdir ai-terraform-lab
cd ai-terraform-lab
code .
```

### Lab Exercise 1: Three-Tier Web Application

**Objective**: Build a complete three-tier architecture using AI assistance

**Requirements**:
- **Presentation Tier**: Static Web App for frontend
- **Application Tier**: Container Apps for API services
- **Data Tier**: Cosmos DB for NoSQL data, SQL Database for relational data
- **Cross-cutting**: Monitoring, security, networking

**Step 1: Foundation Infrastructure**

Create `01-foundation.tf`:
```terraform
# Three-Tier Web Application Infrastructure
# 
# Application: Customer Management System
# Traffic: Expected 5,000 daily active users
# Data: Customer records, order history, product catalog
# Security: PCI DSS compliance required for payment data
# Performance: 99.5% uptime SLA, <200ms API response time
# 
# Architecture Tiers:
# 1. Presentation: React.js SPA hosted on Azure Static Web Apps
# 2. Application: Node.js API services on Azure Container Apps
# 3. Data: Azure Cosmos DB (product catalog) + Azure SQL (transactions)
# 
# Environment: Production
# Region: East US 2 (primary)

# [Let AI generate the foundation infrastructure]
```

**Expected Generated Foundation**:
```terraform
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-cms-prod-eastus2"
  location = "East US 2"
  
  tags = {
    Environment   = "Production"
    Application   = "CustomerManagement"
    Compliance    = "PCI-DSS"
    ManagedBy     = "Terraform"
  }
}

# Virtual Network for secure communication
resource "azurerm_virtual_network" "main" {
  name                = "vnet-cms-prod"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  
  tags = azurerm_resource_group.main.tags
}

# Subnets for each tier
resource "azurerm_subnet" "app_subnet" {
  name                 = "snet-app-tier"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "data_subnet" {
  name                 = "snet-data-tier"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.2.0/24"]
}
```

### Lab Exercise 2: AI-Assisted Refactoring

**Objective**: Take existing monolithic configuration and refactor into modules

**Starting Configuration**:
```terraform
# Existing monolithic main.tf (provided in demo-resources/)
# Contains all resources in a single file
# Goal: Refactor into logical modules using AI assistance
```

**Refactoring Steps**:

1. **Identify Module Boundaries**
   ```
   Chat Prompt: "Analyze this Terraform configuration and suggest how to break it into logical modules. Consider separation of concerns, reusability, and maintainability."
   ```

2. **Create Module Structure**
   ```
   Chat Prompt: "Create the directory structure and module files for the suggested architecture. Include proper variable definitions and outputs for each module."
   ```

3. **Extract Common Patterns**
   ```
   Chat Prompt: "Identify repeated patterns in this configuration that could be abstracted into reusable modules."
   ```

### Lab Exercise 3: Environment Scaling with AI

**Objective**: Create environment-specific configurations using AI pattern recognition

**Base Configuration (Development)**:
```terraform
# Development environment - cost optimized
variable "environment" {
  default = "dev"
}

locals {
  is_prod = var.environment == "prod"
  is_staging = var.environment == "staging"
  is_dev = var.environment == "dev"
}

# AI will recognize environment patterns and suggest appropriate scaling
resource "azurerm_app_service_plan" "main" {
  # Start with basic configuration
  # Let AI suggest environment-specific modifications
}
```

**Production Scaling Prompt**:
```terraform
# Convert the above development configuration to production-ready
# Requirements for production:
# - High availability with multiple zones
# - Auto-scaling based on CPU and memory metrics
# - Premium SKUs with enhanced performance
# - Enhanced security and monitoring
# - Backup and disaster recovery configured

# [Let AI transform the configuration for production requirements]
```

---

## Code Quality and Best Practices with AI

### AI-Assisted Code Reviews

**Using Copilot Chat for Reviews**:
```
Prompt: "Review this Terraform configuration for best practices. Check for:
1. Resource naming conventions
2. Security configurations
3. Performance optimizations
4. Cost implications
5. Maintainability issues

Provide specific recommendations with code examples."
```

### Generating Tests and Validation

**Test Generation Prompt**:
```terraform
# Generate comprehensive tests for this infrastructure
# Include: Resource existence, configuration validation, security tests
# Framework: Terratest with Go, or similar testing approach
# Coverage: All critical resources and their key properties

# [Copilot generates test files and validation scripts]
```

### Documentation Generation

**Documentation Prompt**:
```
"Generate comprehensive documentation for this Terraform configuration including:
1. Architecture overview with diagrams
2. Resource descriptions and purposes
3. Variable explanations and valid values
4. Output descriptions
5. Deployment instructions
6. Troubleshooting guide"
```

---

## Working with Existing Codebases

### Understanding Legacy Code

**Analysis Prompt**:
```
"Explain this existing Terraform configuration. Identify:
1. What infrastructure is being created
2. The relationships between resources
3. Potential security concerns
4. Opportunities for improvement
5. Missing best practices"
```

### Modernizing Configurations

**Modernization Prompt**:
```terraform
# Legacy configuration using older patterns
resource "azurerm_virtual_machine" "web" {
  # Old VM-based approach
  name                = "vm-web"
  # ... legacy configuration
}

# Prompt: "Modernize this infrastructure to use current Azure best practices"
# Expected: Suggestions to use Container Apps, App Services, or AKS
# Include: Managed services, better security, improved scalability
```

### Migration Assistance

**Migration Scenarios**:
```
"Help me migrate this AWS infrastructure to Azure using Terraform:
[Paste AWS Terraform configuration]

Requirements:
- Maintain equivalent functionality
- Use Azure-native services where possible
- Optimize for Azure best practices
- Ensure security configurations transfer appropriately"
```

---

## Advanced Multi-File Projects

### Project Structure Recognition

Copilot understands complex project structures:

```
terraform-project/
├── main.tf                    # Main resources
├── variables.tf              # Input variables
├── outputs.tf               # Output values
├── locals.tf                # Local values
├── data.tf                  # Data sources
├── providers.tf             # Provider configurations
├── versions.tf              # Version constraints
├── environments/
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── prod.tfvars
└── modules/
    ├── networking/
    ├── compute/
    └── security/
```

### Cross-File Context Awareness

When editing any file, Copilot considers:
- Variables defined in `variables.tf`
- Resources in `main.tf`
- Local values in `locals.tf`
- Data sources in `data.tf`
- Module outputs and inputs

**Example**: When adding an output in `outputs.tf`, Copilot suggests based on resources in `main.tf`:

```terraform
# In outputs.tf - Copilot knows about resources from main.tf
output "web_app_url" {
  description = "URL of the web application"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "database_connection_string" {
  description = "Connection string for the database"
  value       = azurerm_postgresql_server.main.fqdn
  sensitive   = true
}
```

---

## Performance and Optimization Tips

### 1. Optimize AI Context

**Best Practices**:
- Keep related files open in tabs
- Use descriptive comments and names
- Maintain consistent project structure
- Include relevant documentation files

### 2. Efficient Prompt Strategies

**Iterative Development**:
```terraform
# Stage 1: Basic structure
# Create a basic web application infrastructure

# Stage 2: Add security
# Add security features to the above infrastructure

# Stage 3: Add monitoring  
# Complete the infrastructure with monitoring and alerting
```

### 3. Leverage AI for Documentation

**Auto-Documentation**:
```
"Generate a README.md for this Terraform project including:
- Project overview and purpose
- Prerequisites and setup instructions  
- Usage examples and deployment steps
- Architecture diagrams using Mermaid
- Variable descriptions and examples
- Troubleshooting common issues"
```

---

## Hands-On Workshop Activity

### Workshop Challenge: Complete Infrastructure Build

**Time Limit**: 45 minutes  
**Objective**: Build a complete production-ready infrastructure using AI assistance

**Scenario**: 
Deploy a modern web application with the following requirements:
- **Frontend**: Static React.js application
- **Backend**: Containerized Node.js API with auto-scaling
- **Database**: Managed PostgreSQL with backup
- **Storage**: Object storage for file uploads
- **Security**: Key Vault, managed identities, private networking
- **Monitoring**: Application Insights and Log Analytics
- **CDN**: Content delivery network for global performance

**Challenge Rules**:
1. Use AI assistance for at least 80% of code generation
2. Include proper variable definitions and outputs
3. Implement security best practices
4. Add appropriate tags and naming conventions
5. Include basic documentation

**Evaluation Criteria**:
- Infrastructure completeness and correctness
- Effective use of AI assistance
- Security implementation
- Code organization and quality
- Documentation clarity

---

## Session Wrap-up

### Key Takeaways

1. **AI excels at pattern recognition** and can generate complex infrastructure based on context
2. **Prompt engineering is crucial** for getting relevant, high-quality suggestions
3. **Iterative refinement** produces better results than trying to generate everything at once
4. **Context awareness** across files enables sophisticated code generation
5. **AI assists with refactoring** and modernization of existing configurations
6. **Always review and validate** AI-generated code for correctness and security

### Advanced Techniques Learned

- Multi-layer infrastructure prompting
- Environment-aware configuration generation
- Security-first AI prompting
- Cross-file context utilization
- Pattern-based scaling and optimization

### What's Next?

In Session 3, we'll explore:
- Prompt engineering mastery
- Complex debugging scenarios
- AI-assisted architecture decisions
- Advanced refactoring techniques
- Team collaboration with AI tools

---

**Next**: [Session 3: Advanced AI Techniques & Best Practices](03-advanced-techniques.md)
