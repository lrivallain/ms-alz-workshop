# Module 1: Azure Landing Zones with Terraform - Fundamentals

## Learning Objectives
After completing this module, you will be able to:
- Explain the difference between Platform and Application Landing Zones
- Identify the key components of an Azure Landing Zone architecture
- Choose the appropriate Terraform implementation approach for your organization
- Understand state management strategies for complex ALZ deployments

## Prerequisites
- Basic understanding of Azure services and concepts
- Familiarity with Terraform basics (resources, modules, state)
- Azure subscription with appropriate permissions

## What are Azure Landing Zones?

Azure Landing Zones (ALZ) provide a comprehensive framework for deploying and operating Azure environments at enterprise scale. Think of them as the "foundation" that organizations build their Azure workloads on top of.

### Key Principles
1. **Security by Default**: All components are configured with security best practices
2. **Scalability**: Architecture supports growth from small to enterprise scale
3. **Governance**: Consistent policies and compliance across all environments
4. **Operational Excellence**: Standardized monitoring, alerting, and management

## Platform vs Application Landing Zones

### Platform Landing Zone (The Foundation)
The Platform Landing Zone is the **shared foundation** that supports all workloads in your organization.

**Components:**
- **Management Groups**: Hierarchical organization structure for governance
- **Policies**: Governance rules applied consistently across subscriptions
- **Connectivity**: Hub networks, firewalls, VPN/ExpressRoute connections
- **Management**: Centralized logging, monitoring, and automation
- **Identity**: Shared identity services and access management

**Who owns it?** Typically the **Cloud Platform Team** or **Infrastructure Team**

**Example:** Think of this like the utilities in an office building - electricity, water, HVAC, security systems. Every tenant needs them, but they're managed centrally.

### Application Landing Zone (The Workloads)
Application Landing Zones are **individual workload environments** that consume services from the Platform Landing Zone.

**Components:**
- **Subscriptions**: Isolated billing and governance boundaries for workloads
- **Virtual Networks**: Spoke networks that connect to the platform hub
- **Resource Groups**: Logical containers for application resources
- **Identities**: Application-specific managed identities
- **Budgets**: Cost management for the specific workload
- **Application Resources**: Key Vault, Storage, databases, compute, etc.

**Who owns it?** Typically **Application Teams** or **Development Teams**

**Example:** Think of these like individual offices or apartments in the building - each has their own space, resources, and purpose, but they all connect to the shared utilities.

## ALZ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Management Groups                             │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │    Root     │  │   Platform   │  │    Landing Zones        │ │
│  └─────────────┘  └──────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Platform Services                             │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │ Connectivity│  │  Management  │  │       Identity          │ │
│  │   (Hub)     │  │   (Logging)  │  │    (Azure AD)           │ │
│  └─────────────┘  └──────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│              Application Landing Zones                          │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────────────────┐ │
│  │ Production  │  │    Staging   │  │      Development        │ │
│  │  Workload   │  │   Workload   │  │       Workload          │ │
│  └─────────────┘  └──────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Terraform Implementation Options

### For Platform Landing Zones (Foundation)

#### Option 1: ALZ Terraform Accelerator Bootstrap (AVM-Based) ⭐ **RECOMMENDED**
**Best for: Rapid platform deployment with modern patterns**

- **Tool**: ALZ PowerShell module with `Deploy-Accelerator` command
- **Underlying Modules**: Uses AVM pattern modules (`avm-ptn-alz-*`) automatically
- **Approach**: Automated bootstrap that generates Terraform code using current AVM modules
- **Pros**: Fast deployment, current best practices, GitHub integration, automated workflows
- **Cons**: Less initial transparency, opinionated structure
- **When to use**: When you want to get a production-ready platform quickly with current Microsoft guidance

#### Option 2: Manual Configuration with AVM Pattern Modules ⚠️ **NOT RECOMMENDED**
**Best for: Learning purposes only**

- **Modules**: `avm-ptn-alz`, `avm-ptn-alz-management`, `avm-ptn-alz-connectivity`
- **Approach**: Manually compose individual AVM modules to build your platform
- **Pros**: Complete control, transparent, composable, understand every component
- **Cons**: Very complex, requires deep Terraform knowledge, long setup time, error-prone
- **When to use**: Only for learning ALZ concepts or extreme customization needs

#### Option 3: Manual Terraform Configuration (No AVM) ⚠️ **NOT RECOMMENDED**
**Best for: Legacy or highly customized environments**

- **Resources**: Native Terraform resources (`azurerm_management_group`, `azurerm_policy_assignment`, etc.)
- **Approach**: Write all Terraform configurations from scratch without any modules
- **Pros**: Complete control over every resource, no module dependencies
- **Cons**: Extremely complex, error-prone, no best practices, high maintenance, reinventing the wheel
- **When to use**: Only for legacy environments or when AVM modules absolutely cannot meet requirements

### For Application Landing Zones (Workloads)

#### Option 1: Landing Zone Vending ⭐ **RECOMMENDED**
**Best for: Standardized workload onboarding at scale**

- **Module**: `Azure/lz-vending/azurerm`
- **Approach**: Automated subscription creation with standardized scaffolding
- **Pros**: Automated subscription lifecycle, consistent patterns, great for scale
- **Cons**: Less flexibility per workload, focused on subscription management
- **When to use**: When you need to create many standardized workload environments efficiently

#### Option 2: Manual Configuration with AVM Resource Modules 🔵 **ADVANCED: For custom workloads**
**Best for: Unique custom workload requirements**

- **Modules**: Individual AVM resource modules (`avm-res-*`)
- **Approach**: Manually define subscriptions, networking, and application resources using AVM modules
- **Pros**: Complete control over workload architecture, uses Azure best practices
- **Cons**: Much more work for each workload, potential for inconsistency, maintenance overhead
- **When to use**: Only when workloads have very unique requirements that can't be handled by Landing Zone Vending

#### Option 3: Manual Terraform Configuration (No AVM) ⚠️ **NOT RECOMMENDED**
**Best for: Legacy workloads or extreme customization**

- **Resources**: Native Terraform resources (`azurerm_resource_group`, `azurerm_virtual_network`, etc.)
- **Approach**: Write all workload configurations from scratch without any modules
- **Pros**: Complete control over every resource and configuration
- **Cons**: No best practices, error-prone, high maintenance, inconsistent patterns
- **When to use**: Only for legacy workloads or when AVM modules cannot meet specific requirements

### Recommended Enterprise Approach
**Best for: Most production scenarios**

1. **Platform Foundation**: ⭐ ALZ Accelerator Bootstrap for rapid, current platform deployment
2. **Workload Onboarding**: ⭐ Landing Zone Vending for standardized application environments  
3. **Custom Resources**: Only use manual AVM resource modules when Landing Zone Vending cannot meet requirements
4. **Avoid**: Manual Terraform without AVM (only for legacy or extreme edge cases)

## State Management Strategy

One of the most important decisions in ALZ implementation is how to organize your Terraform state files.

### Recommended State Separation

```
terraform-states/
├── bootstrap/                 # Management Groups, Core Policies
│   └── terraform.tfstate
├── platform/                  # Connectivity, Management Platform
│   ├── connectivity/
│   │   └── terraform.tfstate
│   └── management/
│       └── terraform.tfstate
├── landing-zones/             # Individual Workloads
│   ├── ecommerce-prod/
│   │   └── terraform.tfstate
│   ├── ecommerce-dev/
│   │   └── terraform.tfstate
│   └── analytics-prod/
│       └── terraform.tfstate
└── shared-services/           # Cross-cutting services
    └── terraform.tfstate
```

### Why Separate States?

1. **Reduced Blast Radius**: Issues in one area don't affect others
2. **Team Ownership**: Different teams can manage different layers
3. **Deployment Speed**: Smaller state files = faster operations
4. **Security**: Different access levels for different layers

### State Backend Configuration

Use Azure Storage with Azure AD authentication:

```terraform
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate001"
    container_name       = "tfstate"
    key                  = "bootstrap/terraform.tfstate"
    use_azuread_auth     = true  # Use Azure AD instead of access keys
  }
}
```

## Decision Framework

Use this decision tree to choose your implementation approach:

```
Do you need a Platform Landing Zone (foundation)?
├── Yes → Use ALZ Accelerator Bootstrap (RECOMMENDED)
│   ├── Alternative 1: Manual AVM pattern modules (NOT RECOMMENDED - learning only)
│   └── Alternative 2: Manual Terraform without AVM (NOT RECOMMENDED - legacy only)
└── No → Do you need Application Landing Zones (workloads)?
    ├── Yes → Use Landing Zone Vending (RECOMMENDED)
    │   ├── Alternative 1: Manual with AVM resource modules (ADVANCED - unique cases)
    │   └── Alternative 2: Manual Terraform without AVM (NOT RECOMMENDED - legacy only)
    └── No → Use individual AVM resource modules for specific resources
```

## Common Patterns and Anti-Patterns

### ✅ Good Practices

1. **Start Small**: Begin with a single management group and expand
2. **Separate Concerns**: Use different state files for different layers
3. **Version Control**: Pin module versions and upgrade deliberately
4. **Documentation**: Document decisions and configurations
5. **Testing**: Test in non-production environments first

### ❌ Anti-Patterns

1. **Monolithic State**: Putting everything in one huge state file
2. **Manual Drift**: Making changes outside of Terraform
3. **Version Chaos**: Using different provider versions across modules
4. **No Governance**: Skipping policies and compliance controls
5. **Overly Complex**: Trying to implement everything at once

## Next Steps

Now that you understand the fundamentals, you're ready to dive into specific implementation approaches:

- **Module 2**: Implement ALZ using AVM Pattern Modules (manual approach)
- **Module 3**: Deploy with ALZ Terraform Accelerator (AVM-based bootstrap)
- **Module 4**: Manage workload subscriptions with Landing Zone Vending
- **Module 5**: Build an end-to-end implementation combining all approaches

## Knowledge Check

Before moving to the next module, ensure you can answer these questions:

1. What's the difference between a Platform Landing Zone and an Application Landing Zone?
2. When would you choose ALZ Accelerator Bootstrap vs. manual AVM module configuration?
3. Why is state separation important in ALZ implementations?
4. What are the key components of a Platform Landing Zone?
5. When would you use Landing Zone Vending vs. manual workload configuration?
6. What's the advantage of the ALZ Accelerator using AVM modules underneath?

---

**Next Module**: [Module 2: Terraform AVM Implementation](02-terraform-avm-implementation.md)
