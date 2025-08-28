# Lab 2: AI-Assisted Infrastructure Development

## Lab Overview
**Duration**: 60 minutes  
**Objective**: Build complete Azure infrastructure using AI assistance and advanced Copilot techniques  
**Prerequisites**: Completed Lab 1, Active Copilot environment, Azure CLI authenticated

---

## Lab Objectives

By the end of this lab, you will:
- Generate complete infrastructure configurations using AI prompts
- Apply advanced prompt engineering techniques for complex scenarios
- Build a multi-tier application architecture with AI assistance
- Understand context-aware code generation patterns
- Implement infrastructure best practices with AI guidance
- Create reusable and maintainable Terraform modules using AI

---

## Part 1: Advanced Prompt Engineering

### Step 1: SMART Prompting Framework

**Create workspace for advanced prompting**:
```bash
# Create lab directory
mkdir ai-infrastructure-lab
cd ai-infrastructure-lab
code .

# Create directory structure
mkdir environments
mkdir modules
mkdir environments/dev
mkdir environments/staging
mkdir environments/prod
mkdir modules/networking
mkdir modules/compute
mkdir modules/database
mkdir modules/monitoring
```

**Practice SMART prompting** in `01-smart-prompting.tf`:

```terraform
# SMART Prompt Example 1: Specific and Measurable
# SPECIFIC: Create Azure Container Apps environment for microservices
# MEASURABLE: Support 20 concurrent services, handle 5,000 RPS per service
# ACTIONABLE: Include auto-scaling (2-10 replicas), health checks, ingress
# RELEVANT: E-commerce platform with PCI compliance requirements
# TIME-BOUND: Must deploy within regulatory approval window (60 days)
#
# Additional Context:
# - Budget constraint: $1,500/month maximum
# - Region: East US (data residency requirement)
# - Integration: Must connect to existing Azure AD B2C
# - Performance: <200ms p95 latency, 99.5% availability SLA

# [Let Copilot generate the infrastructure based on this comprehensive prompt]
```

**Expected AI Generation**:
```terraform
resource "azurerm_resource_group" "ecommerce_microservices" {
  name     = "rg-ecommerce-microservices-eastus"
  location = "East US"
  
  tags = {
    Environment    = "Production"
    Project       = "ECommercePlatform"
    Compliance    = "PCI-DSS"
    ManagedBy     = "Terraform"
    Budget        = "1500-monthly"
    DataResidency = "US-Only"
  }
}

resource "azurerm_log_analytics_workspace" "microservices" {
  name                = "log-ecommerce-microservices"
  location           = azurerm_resource_group.ecommerce_microservices.location
  resource_group_name = azurerm_resource_group.ecommerce_microservices.name
  sku               = "PerGB2018"
  retention_in_days = 90  # PCI compliance requirement
  
  tags = azurerm_resource_group.ecommerce_microservices.tags
}

resource "azurerm_container_app_environment" "microservices" {
  name                       = "cae-ecommerce-microservices"
  location                  = azurerm_resource_group.ecommerce_microservices.location
  resource_group_name       = azurerm_resource_group.ecommerce_microservices.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.microservices.id
  
  tags = azurerm_resource_group.ecommerce_microservices.tags
}
```

### Step 2: Context-Driven Generation

**Create context-rich environment** in `02-context-driven.tf`:

```terraform
# Context-Driven Infrastructure Generation
# 
# Business Context: Global SaaS platform serving 50,000+ users
# Technical Context: React frontend, Node.js APIs, PostgreSQL database
# Operational Context: DevOps team of 4, CI/CD with GitHub Actions
# Security Context: SOC 2 compliance, customer data protection
# 
# Current Pain Points:
# - Manual scaling during traffic spikes (3x during business hours)
# - Database backup/restore takes 4+ hours
# - No disaster recovery plan (RTO: 4 hours, RPO: 1 hour targets)
# - Limited monitoring and alerting capabilities
# - High cloud costs ($8,000/month, target: $6,000)
# 
# Success Criteria:
# - Auto-scaling based on CPU/memory/requests
# - Database backup/restore <30 minutes
# - Multi-region deployment capability
# - Comprehensive monitoring dashboard
# - 25% cost reduction while improving performance

# Phase 1: Core Infrastructure with Auto-scaling
# Generate the foundational infrastructure addressing the pain points above
```

**Expected AI Response Pattern**:
```terraform
# AI should generate infrastructure that addresses specific pain points:
# - Auto-scaling app services
# - Optimized database configurations
# - Disaster recovery setup
# - Comprehensive monitoring
# - Cost-optimized resource selections

locals {
  common_tags = {
    Project     = "SaaSPlatform"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_service_plan" "saas_platform" {
  name                = "asp-saas-platform-prod"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  
  # Cost-optimized but scalable
  os_type  = "Linux"
  sku_name = "P1v3"  # Balance of performance and cost
  
  # Auto-scaling configuration
  maximum_elastic_worker_count = 10
  worker_count                = 2  # Start with 2 instances
  
  tags = local.common_tags
}

resource "azurerm_linux_web_app" "saas_api" {
  name                = "app-saas-api-prod"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_service_plan.saas_platform.location
  service_plan_id    = azurerm_service_plan.saas_platform.id
  
  site_config {
    # Performance optimizations
    always_on                    = true
    http2_enabled               = true
    application_stack {
      node_version = "18-lts"
    }
    
    # Auto-scaling triggers
    auto_heal_enabled = true
    health_check_path = "/api/health"
  }
  
  # Auto-scaling rules will be added based on CPU/memory/requests
  tags = local.common_tags
}
```

---

## Part 2: Building Multi-Tier Architecture

### Step 1: Architecture Planning with AI

**Use Copilot Chat for architecture planning**:

```
Chat Prompt: "I need to design a three-tier architecture for a modern web application:

Tier 1: Presentation Layer (React SPA)
- Global CDN for static assets
- Custom domain with SSL
- Geographic distribution for performance

Tier 2: Application Layer (Node.js microservices)
- Auto-scaling API services
- Service-to-service communication
- API gateway for routing and security
- Background job processing

Tier 3: Data Layer
- Primary database (PostgreSQL for transactions)
- Cache layer (Redis for session/temporary data)
- Object storage (file uploads and media)
- Search engine (full-text search capabilities)

Requirements:
- Handle 100,000+ daily active users
- 99.9% availability SLA
- <200ms API response times globally
- GDPR compliance for EU users
- Cost target: $5,000/month

Design the Azure architecture and generate initial Terraform configuration."
```

**Create architecture implementation** in `03-three-tier-architecture.tf`:

```terraform
# Three-Tier Architecture Implementation
# Based on AI architectural consultation above

# Tier 1: Presentation Layer - Static Web App with CDN
# Generate secure, performant frontend hosting with global distribution

# Tier 2: Application Layer - Container Apps with API Management
# Create scalable microservices platform with service mesh capabilities

# Tier 3: Data Layer - Multi-database architecture with caching
# Implement polyglot persistence with performance optimization

# Let AI generate the complete architecture based on the chat consultation
```

### Step 2: Tier-by-Tier Implementation

**Tier 1: Presentation Layer**:
```terraform
# In modules/presentation/main.tf
# Presentation Tier Infrastructure
# 
# Requirements from architecture consultation:
# - React SPA hosting with CDN
# - Custom domain and SSL certificates
# - Global performance optimization
# - Security headers and policies

# [Let AI generate the presentation tier infrastructure]

# Expected generation:
resource "azurerm_static_site" "webapp_frontend" {
  name                = "stapp-webapp-frontend"
  resource_group_name = var.resource_group_name
  location           = var.location
  sku_tier           = "Standard"
  sku_size           = "Standard"
  
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.common_tags
}

resource "azurerm_cdn_profile" "webapp" {
  name                = "cdnp-webapp-global"
  location           = "global"
  resource_group_name = var.resource_group_name
  sku                = "Standard_Microsoft"
  
  tags = var.common_tags
}

resource "azurerm_cdn_endpoint" "webapp" {
  name                = "cdne-webapp-${random_string.unique.result}"
  profile_name        = azurerm_cdn_profile.webapp.name
  location           = azurerm_cdn_profile.webapp.location
  resource_group_name = var.resource_group_name
  
  origin {
    name      = "webapp-frontend"
    host_name = azurerm_static_site.webapp_frontend.default_host_name
  }
  
  global_delivery_rule {
    cache_expiration_action {
      behavior = "Override"
      duration = "7.00:00:00"  # 7 days for static assets
    }
    
    cache_key_query_string_action {
      behavior = "IncludeAll"
    }
  }
  
  tags = var.common_tags
}
```

**Tier 2: Application Layer**:
```terraform
# In modules/application/main.tf
# Application Tier Infrastructure
#
# Microservices architecture requirements:
# - Container Apps for API services
# - API Management for routing and security
# - Service Bus for async communication
# - Auto-scaling based on metrics

# [Let AI generate the application tier infrastructure]
```

**Tier 3: Data Layer**:
```terraform
# In modules/data/main.tf
# Data Tier Infrastructure
#
# Polyglot persistence requirements:
# - PostgreSQL for transactional data
# - Redis for caching and sessions
# - Cosmos DB for user profiles and analytics
# - Storage accounts for file uploads

# [Let AI generate the data tier infrastructure]
```

---

## Part 3: Advanced AI Techniques

### Step 1: Pattern-Based Generation

**Create pattern establishment** in `04-pattern-recognition.tf`:

```terraform
# Pattern Recognition Exercise
# Establish patterns and let AI complete similar resources

# Pattern 1: Environment-specific resource groups
resource "azurerm_resource_group" "dev" {
  name     = "rg-webapp-dev-eastus"
  location = "East US"
  
  tags = {
    Environment    = "Development"
    Project       = "WebApp"
    CostCenter    = "Engineering"
    Owner         = "DevTeam"
    ManagedBy     = "Terraform"
    BackupPolicy  = "Dev"
  }
}

# Now type similar resource for staging - observe AI pattern recognition
resource "azurerm_resource_group" "staging" {
  # AI should recognize the pattern and suggest:
  # - Similar naming convention
  # - Adjusted tags for staging
  # - Potentially different location or configuration
}

# Pattern 2: Storage accounts with consistent security
resource "random_string" "dev" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "dev_storage" {
  name                = "stwebappdev${random_string.dev.result}"
  resource_group_name = azurerm_resource_group.dev.name
  location           = azurerm_resource_group.dev.location
  
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind            = "StorageV2"
  
  # Security baseline
  public_network_access_enabled = false
  shared_access_key_enabled     = false
  https_traffic_only_enabled    = true
  min_tls_version              = "TLS1_2"
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
  }
  
  tags = azurerm_resource_group.dev.tags
}

# Create staging storage - let AI adapt the pattern
resource "azurerm_storage_account" "staging_storage" {
  # AI should adapt:
  # - Name for staging environment
  # - Potentially GRS replication for staging
  # - Longer retention periods
  # - Same security baseline
}
```

### Step 2: AI-Assisted Refactoring

**Create legacy configuration for refactoring** in `05-legacy-refactoring.tf`:

```terraform
# Legacy Configuration (intentionally problematic)
# Use AI to modernize and improve this configuration

resource "azurerm_network_interface" "web" {
  name                = "nic-web"
  location            = "East US"
  resource_group_name = "rg-webapp"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-webapp/providers/Microsoft.Network/virtualNetworks/vnet-webapp/subnets/default" # Replace with a valid subnet ID
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "web" {
  name                = "vm-web"
  location           = "East US"
  resource_group_name = "rg-webapp"
  network_interface_ids = [azurerm_network_interface.web.id]
  vm_size            = "Standard_D2s_v3"
  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# AI Refactoring Prompt:
# "Modernize this VM-based web application to use Azure App Service or Container Apps"
# "Improve security, scalability, and operational efficiency"
# "Include proper naming conventions and tagging"
# "Add monitoring and backup capabilities"
```

**AI-guided refactoring prompt in Copilot Chat**:
```
"Refactor this legacy virtual machine configuration to modern Azure services:

Requirements for modernization:
1. Replace VM with appropriate PaaS service (App Service or Container Apps)
2. Implement proper security (managed identity, no hardcoded passwords)
3. Add auto-scaling capabilities
4. Include monitoring and diagnostics
5. Implement proper backup and disaster recovery
6. Follow Azure naming conventions
7. Add comprehensive tagging strategy
8. Ensure cost optimization

Please provide the modernized Terraform configuration with explanations."
```

### Step 3: Multi-File Context Generation

**Create module structure for context testing**:
```bash
# Create comprehensive module structure
mkdir -p modules/webapp/{networking,compute,database,monitoring}
```

**Base configuration in** `modules/webapp/variables.tf`:
```terraform
# Module Variables - Establish Context
variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters and numbers."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "East US"
}

# Application-specific variables
variable "app_settings" {
  description = "Application settings for the web app"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "database_config" {
  description = "Database configuration settings"
  type = object({
    sku_name           = string
    max_size_gb        = number
    backup_retention   = number
    geo_redundant     = bool
  })
  
  default = {
    sku_name           = "Basic"
    max_size_gb        = 2
    backup_retention   = 7
    geo_redundant     = false
  }
}
```

**Test context awareness in** `modules/webapp/main.tf`:
```terraform
# Main Module Configuration
# Test: Does AI understand variables and use them appropriately?

# Local values for consistent naming
locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "webapp"
  }
}

# Test: AI should reference local.resource_prefix and local.common_tags
# Create comprehensive web application infrastructure
# Include: resource group, app service, database, storage, monitoring

# [Let AI generate the complete infrastructure using established context]
```

---

## Part 4: Real-World Scenario Implementation

### Step 1: E-Commerce Platform Build

**Scenario Setup**:
Create `06-ecommerce-platform.tf` with this comprehensive prompt:

```terraform
# Real-World Scenario: E-Commerce Platform
# 
# Business Context:
# - Online retailer with 500+ products
# - 10,000 daily visitors, 3x traffic during sales
# - Global customer base (US, EU, APAC)
# - Payment processing integration required
# - Inventory management system integration
# 
# Technical Requirements:
# - React.js frontend with Next.js for SEO
# - Node.js API backend with microservices architecture
# - Product catalog search (Elasticsearch/Azure Cognitive Search)
# - Real-time inventory updates
# - Payment processing (PCI compliance)
# - Order fulfillment workflow automation
# - Customer support chat integration
# 
# Operational Requirements:
# - 99.9% uptime SLA
# - <2 second page load times globally
# - Auto-scaling for traffic spikes
# - Disaster recovery (RTO: 1 hour, RPO: 15 minutes)
# - Comprehensive monitoring and alerting
# - Cost optimization (target: $3,000/month)
# 
# Compliance Requirements:
# - PCI DSS for payment processing
# - GDPR for EU customers
# - SOC 2 Type II certification
# - Regular security audits
# 
# Generate the complete Azure infrastructure for this e-commerce platform:
```

**Expected comprehensive AI generation** should include:
- Frontend hosting (Static Web Apps + CDN)
- API services (Container Apps or App Service)
- Database layer (Azure SQL + Cosmos DB + Redis Cache)
- Search capabilities (Azure Cognitive Search)
- Payment processing integration points
- Security services (Key Vault, Security Center)
- Monitoring and logging (Application Insights, Log Analytics)
- Backup and disaster recovery
- Auto-scaling configurations
- Cost optimization settings

### Step 2: Microservices Architecture

**Create microservices prompt** in `07-microservices-architecture.tf`:

```terraform
# Microservices Architecture for E-Commerce
# 
# Service Architecture:
# ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
# │  User Service   │  │ Product Service │  │  Order Service  │
# │ (Authentication)│  │   (Catalog)     │  │  (Processing)   │
# └─────────────────┘  └─────────────────┘  └─────────────────┘
#          │                     │                     │
# ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
# │Payment Service  │  │Inventory Service│  │Notification Svc │
# │  (Transactions) │  │ (Stock Mgmt)    │  │  (Email/SMS)    │
# └─────────────────┘  └─────────────────┘  └─────────────────┘
# 
# Communication Patterns:
# - Synchronous: HTTP/REST via API Management
# - Asynchronous: Azure Service Bus for events
# - Data: Event sourcing with Azure Event Hubs
# 
# Scaling Requirements:
# - User Service: 2-10 instances
# - Product Service: 3-15 instances (high read load)
# - Order Service: 2-20 instances (variable load)
# - Payment Service: 2-5 instances (secure, reliable)
# 
# Generate Container Apps infrastructure for this microservices architecture:
```

---

## Part 5: Quality Assurance and Testing

### Step 1: AI-Generated Testing

**Create testing infrastructure** in `08-testing-validation.tf`:

```terraform
# Testing and Validation Infrastructure
# 
# Requirements:
# - Automated infrastructure testing with Terratest
# - Security scanning with tfsec and Checkov
# - Performance testing environments
# - Compliance validation automation
# - Cost analysis and budget alerts
# 
# Generate comprehensive testing and validation infrastructure:

# Testing Resource Group (separate from production)
# Load testing services
# Security scanning automation
# Monitoring and alerting for tests
# Budget controls and cost alerts
```

**Copilot Chat prompt for test generation**:
```
"Generate comprehensive tests for the e-commerce infrastructure:

1. Unit Tests:
   - Resource existence validation
   - Configuration correctness checks
   - Security policy verification

2. Integration Tests:
   - End-to-end connectivity tests
   - Performance benchmarking
   - Disaster recovery validation

3. Security Tests:
   - Penetration testing automation
   - Compliance scanning
   - Vulnerability assessments

4. Operational Tests:
   - Backup and restore procedures
   - Auto-scaling validation
   - Monitoring effectiveness

Provide Terratest-based Go code and supporting infrastructure."
```

### Step 2: Documentation Generation

**Use AI for comprehensive documentation**:

```
Chat Prompt: "Generate comprehensive documentation for the e-commerce infrastructure:

1. Architecture Overview:
   - System architecture diagram (Mermaid)
   - Component relationships
   - Data flow documentation
   - Security architecture

2. Deployment Guide:
   - Prerequisites and setup
   - Step-by-step deployment instructions
   - Environment-specific configurations
   - Troubleshooting common issues

3. Operational Runbook:
   - Monitoring and alerting procedures
   - Incident response workflows
   - Backup and recovery procedures
   - Performance tuning guidelines

4. Security Documentation:
   - Security controls implemented
   - Compliance reporting
   - Access control procedures
   - Security incident response

5. Cost Management:
   - Resource cost breakdown
   - Optimization recommendations
   - Budget monitoring setup
   - Cost allocation strategies

Format as markdown with clear sections and examples."
```

---

## Lab Challenges

### Challenge 1: Speed Build (15 minutes)
**Objective**: Build a complete web application infrastructure in 15 minutes using AI

**Requirements**:
- Resource group, App Service, SQL Database, Storage Account
- Include security best practices
- Add monitoring and alerting
- Implement proper tagging and naming

**Evaluation Criteria**:
- Completeness of infrastructure
- Security implementation quality
- Effective use of AI assistance
- Code organization and documentation

### Challenge 2: Legacy Modernization (20 minutes)
**Objective**: Modernize a legacy on-premises application using AI guidance

**Given**: Legacy application description and requirements
**Task**: Generate modern Azure infrastructure with AI assistance
**Focus**: Migration strategy, security improvements, operational efficiency

### Challenge 3: Multi-Environment Pipeline (15 minutes)
**Objective**: Create environment-specific configurations using AI patterns

**Task**: Generate dev/staging/prod configurations with appropriate differences
**Requirements**: Cost optimization for dev, high availability for prod
**Challenge**: Maintain consistency while accommodating environment differences

---

## Lab Wrap-up and Assessment

### Self-Assessment Checklist

**AI Assistance Effectiveness**:
- [ ] Successfully used advanced prompting techniques
- [ ] Generated complex infrastructure configurations
- [ ] Applied AI suggestions appropriately
- [ ] Maintained code quality and security standards
- [ ] Created comprehensive documentation with AI help

**Technical Implementation**:
- [ ] Built complete multi-tier architecture
- [ ] Implemented proper security configurations
- [ ] Created reusable module patterns
- [ ] Added monitoring and operational capabilities
- [ ] Optimized for performance and cost

**Best Practices Application**:
- [ ] Followed Terraform best practices
- [ ] Implemented Azure security recommendations
- [ ] Created maintainable and scalable infrastructure
- [ ] Applied proper naming and tagging conventions
- [ ] Added appropriate validation and error handling

### Key Learnings

1. **Advanced Prompting**: Structured, context-rich prompts yield better results
2. **Pattern Recognition**: AI excels at recognizing and extending established patterns
3. **Context Awareness**: Cross-file context significantly improves suggestion quality
4. **Iterative Refinement**: Best results come from iterative improvement of AI suggestions
5. **Human Oversight**: AI assistance requires validation and human architectural judgment

### Next Steps

**Immediate Actions**:
- Apply learned techniques to current projects
- Practice advanced prompting in daily development
- Establish AI-assisted development workflows

**Continued Learning**:
- Explore AI debugging and troubleshooting techniques
- Learn advanced architectural consultation with AI
- Practice security review processes for AI-generated code

---

## Lab Completion

### Success Criteria

You have successfully completed Lab 2 if:

1. ✅ **Generated complex infrastructure** using advanced AI prompting techniques
2. ✅ **Built multi-tier architecture** with AI assistance and proper patterns
3. ✅ **Applied security best practices** in AI-generated configurations
4. ✅ **Created reusable patterns** that AI can recognize and extend
5. ✅ **Demonstrated quality assessment** of AI-generated code

**Ready for Lab 3**: [Security and Compliance Review](03-security-compliance-review.md)

---

**Excellent work!** You've mastered AI-assisted infrastructure development and can now leverage advanced techniques to build complex, production-ready systems efficiently while maintaining quality standards.
