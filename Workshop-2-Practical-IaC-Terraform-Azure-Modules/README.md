# Workshop 2: Practical IaC—Terraform & Azure Modules

## Overview
A hands-on technical workshop focused on practical implementation of Infrastructure as Code using Terraform and Azure Verified Modules. This workshop is designed for engineers, architects, and operators who need to implement and manage cloud infrastructure.

## Target Audience
- **Software Engineers** building cloud-native applications
- **DevOps Engineers** implementing infrastructure automation
- **Cloud Architects** designing scalable infrastructure
- **Site Reliability Engineers** managing production systems
- **IT Operators** transitioning to cloud infrastructure

## Duration & Format
- **Duration**: 4 hours (Half-day intensive)
- **Format**: Guided Hands-on Lab
- **Environment**: Bring Your Own Device (BYOD) with admin privileges
- **Azure**: Free Azure subscription provided or use existing

## Learning Objectives
By the end of this workshop, participants will:

1. **Set up a complete IaC development environment** with Git, VS Code, Azure CLI, and Terraform
2. **Build and deploy real Azure infrastructure** using Terraform configurations
3. **Leverage Azure Verified Modules** for production-ready infrastructure patterns
4. **Implement CI/CD pipelines** using Azure DevOps YAML for infrastructure deployment
5. **Troubleshoot common deployment issues** and understand debugging techniques

## Prerequisites

### Technical Skills Required
- Basic command-line interface experience (Windows/Linux/macOS)
- Familiarity with Git concepts (clone, commit, push, pull)
- Understanding of cloud concepts (VMs, networks, storage)
- Text editor experience (preferably VS Code)

### Required Software (Pre-Workshop Installation)
Participants should install these tools **before** the workshop:

| Tool | Purpose | Installation Link |
|------|---------|-------------------|
| **Git** | Version control | [git-scm.com](https://git-scm.com/downloads) |
| **VS Code** | Code editor | [code.visualstudio.com](https://code.visualstudio.com/download) |
| **Azure CLI** | Azure management | [docs.microsoft.com/cli/azure/install-azure-cli](https://docs.microsoft.com/cli/azure/install-azure-cli) |
| **Terraform** | Infrastructure provisioning | [developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads) |

### Azure Requirements
- Azure subscription with Contributor access
- Resource quota for: Resource Groups, Storage Accounts, App Services, SQL Database
- Ability to create service principals (for pipeline authentication)

## Workshop Agenda

| Time | Duration | Session | Activity Type |
|------|----------|---------|---------------|
| **09:00-09:30** | 30 min | [Environment Setup & Validation](#session-1) | Guided Setup |
| **09:30-10:30** | 60 min | [Building Basic Terraform Configs](#session-2) | Hands-on Lab |
| **10:30-10:45** | 15 min | **Break** | |
| **10:45-11:45** | 60 min | [Using Azure Verified Modules](#session-3) | Hands-on Lab |
| **11:45-12:45** | 60 min | [Azure DevOps Pipeline Implementation](#session-4) | Hands-on Lab |
| **12:45-13:00** | 15 min | [Troubleshooting & Q&A](#session-5) | Interactive Discussion |

## Session Details

### Session 1: Environment Setup & Validation
**Objective**: Ensure all participants have a working development environment

**Activities**:
- Validate tool installations
- Configure Azure CLI authentication
- Set up VS Code with Terraform extensions
- Create and clone workshop repository
- Test basic Terraform commands

**Lab**: [Environment Setup Lab](labs/01-environment-setup.md)

### Session 2: Building Basic Terraform Configs
**Objective**: Build real Azure infrastructure from scratch using Terraform

**Activities**:
- Create Terraform configuration files
- Deploy Resource Group, Storage Account, and App Service
- Understand Terraform state management
- Practice plan, apply, and destroy workflows
- Implement variables and outputs

**Lab**: [Basic Terraform Configuration Lab](labs/02-basic-terraform-configs.md)

### Session 3: Using Azure Verified Modules
**Objective**: Leverage production-ready infrastructure patterns with AVM

**Activities**:
- Explore Azure Verified Modules registry
- Replace custom resources with AVM modules
- Configure advanced module parameters
- Understand module versioning and updates
- Implement complex infrastructure patterns

**Lab**: [Azure Verified Modules Lab](labs/03-azure-verified-modules.md)

### Session 4: Azure DevOps Pipeline Implementation
**Objective**: Automate infrastructure deployment with CI/CD pipelines

**Activities**:
- Create Azure DevOps project and repository
- Build YAML pipeline for Terraform deployment
- Configure service connections and variable groups
- Implement multi-stage deployments (dev/prod)
- Set up automated testing and validation

**Lab**: [Azure DevOps Pipeline Lab](labs/04-azure-devops-pipelines.md)

### Session 5: Troubleshooting & Q&A
**Objective**: Address common issues and provide debugging strategies

**Activities**:
- Common error scenarios and solutions
- Debugging techniques and tools
- State file corruption recovery
- Authentication troubleshooting
- Resource dependency issues

**Reference**: [Troubleshooting Guide](labs/05-troubleshooting-guide.md)

## Workshop Materials Structure

```
Workshop-2-Practical-IaC-Terraform-Azure-Modules/
├── README.md                           # This file
├── content/                           # Theory and reference materials
│   ├── 01-environment-setup.md       # Tool installation guides
│   ├── 02-terraform-fundamentals.md  # Terraform core concepts
│   ├── 03-azure-verified-modules.md  # AVM patterns and usage
│   ├── 04-pipeline-automation.md     # CI/CD pipeline concepts
│   └── 05-troubleshooting-tips.md    # Common issues and solutions
├── labs/                             # Hands-on lab instructions
│   ├── 01-environment-setup.md      # Lab 1: Environment setup
│   ├── 02-basic-terraform-configs.md # Lab 2: Basic configurations  
│   ├── 03-azure-verified-modules.md  # Lab 3: Using AVM modules
│   ├── 04-azure-devops-pipelines.md  # Lab 4: Pipeline implementation
│   ├── 05-troubleshooting-guide.md   # Lab 5: Debugging techniques
│   └── starter-templates/           # Code templates and examples
└── facilitator/                      # Instructor resources
    ├── facilitator-guide.md         # Teaching instructions
    ├── environment-validation.md    # Pre-workshop checklist
    └── common-issues.md             # Known issues and solutions
```

## Key Technologies Covered

### Core Tools
- **Terraform**: Infrastructure as Code engine
- **Azure CLI**: Azure resource management
- **Git**: Version control and collaboration
- **VS Code**: Development environment
- **Azure DevOps**: CI/CD pipeline platform

### Azure Services
- **Azure Resource Manager**: Resource deployment and management
- **Azure Storage**: Blob storage and state management
- **Azure App Service**: Web application hosting
- **Azure SQL Database**: Managed database service
- **Azure Key Vault**: Secret and certificate management
- **Azure Monitor**: Logging and monitoring

### Development Practices
- **Infrastructure as Code (IaC)**: Declarative infrastructure definition
- **GitOps**: Git-based deployment workflows  
- **Continuous Integration/Continuous Deployment (CI/CD)**: Automated pipelines
- **State Management**: Terraform state best practices
- **Module Patterns**: Reusable infrastructure components

## Success Metrics

Participants will demonstrate success by:

1. **✅ Environment Validation**: Successfully completing all environment setup tasks
2. **✅ Infrastructure Deployment**: Deploying working Azure infrastructure using Terraform
3. **✅ Module Integration**: Implementing Azure Verified Modules in their configurations
4. **✅ Pipeline Creation**: Building and running automated deployment pipelines
5. **✅ Problem Resolution**: Identifying and resolving common deployment issues

## Post-Workshop Resources

### Immediate Next Steps
- [ ] Complete any unfinished lab exercises
- [ ] Set up personal Azure DevOps organization
- [ ] Explore additional Azure Verified Modules
- [ ] Implement infrastructure for a personal project

### Continued Learning
- **Microsoft Learn**: [Terraform on Azure Learning Path](https://docs.microsoft.com/learn/paths/terraform-fundamentals/)
- **HashiCorp Learn**: [Terraform Associate Certification](https://learn.hashicorp.com/terraform)
- **Azure Architecture Center**: [Infrastructure as Code Patterns](https://docs.microsoft.com/azure/architecture/framework/devops/automation-infrastructure)
- **Community**: [Azure DevOps Community](https://dev.azure.com/mseng/AzureDevOpsRoadmap)

### Certification Pathways
- **HashiCorp Certified: Terraform Associate**
- **Microsoft Certified: DevOps Engineer Expert**
- **Microsoft Certified: Azure Solutions Architect Expert**

## Workshop Support

### During Workshop
- **Live Support**: Facilitator and assistant instructors
- **Slack Channel**: Real-time Q&A and collaboration  
- **Screen Sharing**: Individual troubleshooting assistance
- **Breakout Rooms**: Small group problem-solving

### Post-Workshop
- **Follow-up Session**: Optional 1-hour Q&A session (1 week later)
- **Email Support**: Technical questions for 30 days
- **Resource Updates**: Notifications of updated materials and best practices

---

## Getting Started

1. **Pre-Workshop**: Complete [Environment Setup Lab](labs/01-environment-setup.md)
2. **Day of Workshop**: Join with laptop, power adapter, and enthusiasm!
3. **Post-Workshop**: Continue with [Extended Learning Exercises](labs/extended-exercises.md)

---

**Ready to build cloud infrastructure like a pro? Let's get started! 🚀**

*For facilitator instructions and teaching notes, see [Facilitator Guide](facilitator/facilitator-guide.md)*
