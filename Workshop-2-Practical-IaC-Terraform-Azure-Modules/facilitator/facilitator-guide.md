# Workshop 2 Facilitator Guide

## Pre-Workshop Preparation

### 1. Technical Setup Requirements

**Workshop Environment**:
- [ ] Ensure stable internet connection for all participants
- [ ] Test Azure subscription access and quotas
- [ ] Verify screen sharing and breakout room capabilities
- [ ] Prepare backup Azure subscriptions if needed
- [ ] Set up shared communication channels (Slack, Teams, etc.)

**Content Verification**:
- [ ] Review all lab instructions and test procedures
- [ ] Validate code examples in multiple environments (Windows/macOS/Linux)
- [ ] Confirm Azure service availability in target regions
- [ ] Check for any Azure CLI or Terraform version compatibility issues
- [ ] Prepare troubleshooting scenarios and solutions

### 2. Participant Requirements Validation

**Pre-Workshop Checklist** (Send 1 week before):
```markdown
## Required Software Installation

Please install the following tools before the workshop:

### Essential Tools
- [ ] Git (latest version): https://git-scm.com/downloads
- [ ] Visual Studio Code: https://code.visualstudio.com/download
- [ ] Azure CLI: https://docs.microsoft.com/cli/azure/install-azure-cli
- [ ] Terraform: https://developer.hashicorp.com/terraform/downloads

### Azure Account Requirements
- [ ] Active Azure subscription with Contributor access
- [ ] Ability to create resources (verify quotas)
- [ ] Azure CLI authentication working: `az login`

### Validation Commands
Run these commands to verify your setup:
```bash
git --version
az --version
terraform version
code --version
```

If any command fails, please address before the workshop.
```

### 3. Azure Resources and Quotas

**Resource Requirements per Participant**:
- Resource Groups: 2-3
- Storage Accounts: 2-3
- App Service Plans: 2-3
- Web Apps: 2-3
- SQL Servers: 1-2
- SQL Databases: 1-2
- Key Vaults: 1-2
- Application Insights: 1-2
- Log Analytics Workspaces: 1-2

**Quota Verification Script**:
```bash
# Check current quota usage
az vm list-usage --location "East US" --query "[?currentValue>0]" --output table
az network list-usages --location "East US" --query "[?currentValue>0]" --output table

# Check SQL quotas
az sql list-usages --location "East US" --output table
```

---

## Session-by-Session Teaching Guide

### Session 1: Environment Setup & Validation (30 minutes)

#### Opening (5 minutes)
```markdown
Welcome to Workshop 2: Practical IaC with Terraform & Azure Modules

**Today's Objectives**:
- Set up complete IaC development environment
- Build real Azure infrastructure with Terraform
- Leverage Azure Verified Modules
- Implement CI/CD pipelines
- Troubleshoot common deployment issues

**Format**: Hands-on labs with guided assistance
**Support**: Screen sharing, breakout rooms, live chat
```

#### Environment Setup (20 minutes)

**Common Issues and Solutions**:

1. **Azure CLI Installation Issues**:
   ```bash
   # Windows PowerShell execution policy
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   
   # macOS permission issues
   sudo chown -R $(whoami) /usr/local/lib/node_modules
   
   # Linux PATH issues
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Terraform Installation Verification**:
   ```bash
   # If terraform command not found
   # Windows: Check PATH environment variable
   # macOS: brew link terraform
   # Linux: Check /usr/local/bin in PATH
   ```

3. **VS Code Extension Problems**:
   - Reload window: Ctrl+Shift+P → "Developer: Reload Window"
   - Check internet connectivity for extension marketplace
   - Manual extension installation from .vsix files if needed

**Validation Checkpoints**:
- [ ] All participants have tools installed
- [ ] Azure CLI authentication successful
- [ ] VS Code extensions working
- [ ] Basic Terraform commands functional

#### Wrap-up and Questions (5 minutes)
- Address any lingering setup issues
- Preview next session content
- Confirm everyone is ready to proceed

### Session 2: Building Basic Terraform Configs (60 minutes)

#### Introduction (5 minutes)
```markdown
**Session Objectives**:
- Build complete web application infrastructure
- Practice Terraform workflow (init, plan, apply)
- Understand state management
- Implement security best practices
```

#### Guided Development (45 minutes)

**Key Teaching Points**:

1. **Directory Structure Importance** (5 minutes):
   ```bash
   # Explain why structure matters
   terraform/
   ├── environments/     # Environment-specific configs
   ├── modules/         # Reusable modules
   └── shared/          # Common configurations
   ```

2. **Variable Strategy** (10 minutes):
   - Demonstrate validation rules
   - Show environment-specific configurations
   - Explain sensitive variable handling

3. **Resource Dependencies** (10 minutes):
   ```terraform
   # Show implicit vs explicit dependencies
   resource "azurerm_linux_web_app" "main" {
     service_plan_id = azurerm_service_plan.main.id  # Implicit
     depends_on      = [azurerm_storage_account.main] # Explicit
   }
   ```

4. **Security Best Practices** (10 minutes):
   - Never hardcode secrets
   - Use Key Vault references
   - Implement least privilege access
   - Enable audit logging

5. **State Management** (10 minutes):
   - Explain state file purpose
   - Show state commands
   - Discuss remote state benefits

**Common Issues During Lab**:

1. **Resource Naming Conflicts**:
   ```bash
   # If storage account names conflict
   # Add more randomness or use longer unique suffix
   resource "random_string" "unique" {
     length = 8  # Increase from 6
   }
   ```

2. **Azure Provider Authentication**:
   ```bash
   # Re-authenticate if needed
   az logout && az login
   az account set --subscription "correct-subscription"
   ```

3. **SQL Server Authentication Setup**:
   - Help participants understand Azure AD vs SQL authentication
   - Troubleshoot firewall rule issues
   - Explain managed identity concepts

#### Lab Support Strategy

**Breakout Rooms** (when needed):
- Technical issues: Small groups with instructor
- Advanced questions: Separate room for deep dives
- Catch-up sessions: For participants who fall behind

**Code Review Sessions**:
```bash
# Demonstrate these commands periodically
terraform fmt -check=true -diff=true
terraform validate
terraform plan | grep -E "(create|destroy|modify)"
```

#### Wrap-up (10 minutes)
- Review what was built
- Show final outputs
- Address questions
- Preview Azure Verified Modules benefits

### Session 3: Using Azure Verified Modules (60 minutes)

#### Introduction (5 minutes)
```markdown
**Why Azure Verified Modules?**
- Reduce development time by 80%
- Built-in security best practices
- Microsoft support and maintenance
- Production-ready configurations
```

#### AVM Migration Lab (45 minutes)

**Teaching Approach**:
1. **Side-by-Side Comparison** (15 minutes):
   Show custom resource vs AVM module for same functionality

2. **Migration Strategy** (15 minutes):
   ```bash
   # Demonstrate incremental migration approach
   # 1. Plan migration
   terraform plan -out=migration.tfplan
   
   # 2. Apply migration
   terraform apply migration.tfplan
   
   # 3. Verify functionality
   ```

3. **Advanced Configuration** (15 minutes):
   Show complex scenarios with multiple AVM modules

**Key Concepts to Emphasize**:

1. **Module Selection**:
   ```terraform
   # Explain naming conventions
   Azure/avm-res-storage-storageaccount  # Resource module
   Azure/avm-ptn-webapp-privateendpoint  # Pattern module
   ```

2. **Version Pinning**:
   ```terraform
   # Show version strategies
   version = "~> 0.1.0"  # Recommended
   version = "0.1.5"     # Exact (not recommended)
   ```

3. **Configuration Patterns**:
   ```terraform
   # Demonstrate environment-specific configurations
   sku_name = var.environment == "prod" ? "P1v3" : "B1"
   ```

**Troubleshooting AVM Issues**:

1. **Module Source Issues**:
   ```bash
   # Clear module cache
   rm -rf .terraform/modules
   terraform init
   ```

2. **Version Conflicts**:
   ```bash
   # Check available versions
   terraform init -upgrade
   ```

3. **Parameter Validation**:
   - Check module documentation
   - Verify required vs optional parameters
   - Validate input formats

#### Wrap-up (10 minutes)
- Compare before/after configurations
- Highlight maintenance benefits
- Discuss contribution opportunities

### Session 4: Azure DevOps Pipeline Implementation (60 minutes)

#### Introduction (5 minutes)
```markdown
**Pipeline Objectives**:
- Automate infrastructure deployment
- Implement approval gates
- Ensure security and compliance
- Enable team collaboration
```

#### Pipeline Development (45 minutes)

**Service Principal Setup** (10 minutes):
```powershell
# Create service principal for pipeline
$sp = az ad sp create-for-rbac --name "sp-terraform-pipeline" --role "Contributor" --scopes "/subscriptions/$SUBSCRIPTION_ID" --sdk-auth | ConvertFrom-Json

# Display required values for Azure DevOps
Write-Host "Service Connection Values:"
Write-Host "Subscription ID: $($sp.subscriptionId)"
Write-Host "Client ID: $($sp.clientId)"
Write-Host "Client Secret: $($sp.clientSecret)"
Write-Host "Tenant ID: $($sp.tenantId)"
```

**Pipeline YAML Development** (25 minutes):

1. **Basic Pipeline Structure** (10 minutes):
   ```yaml
   # Explain pipeline stages
   stages:
   - stage: Validate    # Syntax and security checks
   - stage: Deploy      # Infrastructure deployment
   - stage: Test       # Post-deployment validation
   ```

2. **Security Integration** (10 minutes):
   ```yaml
   # Show security scanning integration
   - script: |
       tfsec . --format junit --out tfsec-results.xml
     displayName: 'Security Scan'
   ```

3. **Multi-Environment Deployment** (5 minutes):
   ```yaml
   # Demonstrate environment-specific deployments
   - deployment: DeployTerraform
     environment: 'production'  # Requires approval
   ```

**Common Pipeline Issues**:

1. **Service Connection Problems**:
   - Verify service principal permissions
   - Check subscription access
   - Validate connection configuration

2. **State File Access**:
   - Ensure storage account permissions
   - Check container existence
   - Verify state file locks

3. **Agent Capacity**:
   - Monitor Microsoft-hosted agents
   - Consider self-hosted agents for heavy workloads

#### Pipeline Testing (10 minutes)
- Demonstrate pipeline execution
- Show approval process
- Explain monitoring and notifications

### Session 5: Troubleshooting & Q&A (15 minutes)

#### Common Scenarios and Solutions

**Scenario 1: State File Corruption**
```bash
# Recovery procedure
terraform state list
terraform state pull > backup.json
terraform state push backup.json
```

**Scenario 2: Resource Conflicts**
```bash
# Import existing resources
terraform import azurerm_resource_group.main /subscriptions/.../resourceGroups/existing-rg
```

**Scenario 3: Authentication Timeouts**
```bash
# Refresh authentication
az account get-access-token --query accessToken --output tsv
```

**Scenario 4: Module Update Issues**
```bash
# Safely update modules
terraform init -upgrade
terraform plan
```

#### Q&A Best Practices
- Encourage specific questions with context
- Use screen sharing for complex issues
- Document common issues for future workshops
- Follow up via email for unresolved issues

---

## Assessment and Evaluation

### Learning Objective Verification

**Environment Setup Assessment**:
```bash
# Verification script for participants
#!/bin/bash
echo "=== Environment Assessment ==="
git --version && echo "✅ Git installed" || echo "❌ Git missing"
az --version > /dev/null && echo "✅ Azure CLI installed" || echo "❌ Azure CLI missing"
terraform version > /dev/null && echo "✅ Terraform installed" || echo "❌ Terraform missing"
code --version > /dev/null && echo "✅ VS Code installed" || echo "❌ VS Code missing"
```

**Practical Skills Assessment**:
- [ ] Can initialize Terraform project
- [ ] Can plan and apply infrastructure changes
- [ ] Can use Azure Verified Modules
- [ ] Can create basic CI/CD pipeline
- [ ] Can troubleshoot common issues

### Hands-On Competency Checklist

**Infrastructure Development**:
- [ ] Proper directory structure
- [ ] Variable usage and validation
- [ ] Resource dependencies
- [ ] Output configuration
- [ ] Security implementation

**AVM Integration**:
- [ ] Module selection and usage
- [ ] Version management
- [ ] Configuration customization
- [ ] Documentation understanding

**Pipeline Implementation**:
- [ ] YAML pipeline creation
- [ ] Service connection setup
- [ ] Multi-stage deployment
- [ ] Security integration

---

## Workshop Logistics

### Timing Management

**Session Flexibility**:
- Build in 5-10 minute buffers between sessions
- Use polls to check progress: "Raise hand if ready to proceed"
- Have advanced exercises ready for fast finishers
- Prepare catch-up summaries for those falling behind

**Break Management**:
- Take breaks when 25% of participants need help
- Use breakout rooms during breaks for individual support
- Keep main session recording during breaks

### Participant Support Strategies

**Multi-Level Support**:
1. **Self-Service**: Detailed lab instructions with troubleshooting sections
2. **Peer Support**: Encourage participants to help each other
3. **Instructor Support**: Available for complex technical issues
4. **Post-Workshop**: Email support for 30 days

**Communication Channels**:
- Primary: Workshop platform chat
- Secondary: Slack/Teams channel
- Emergency: Direct message to instructors
- Async: Email for follow-up questions

### Technology Contingencies

**Common Failure Scenarios**:

1. **Azure Service Outages**:
   - Monitor Azure Status page before workshop
   - Have alternative regions ready
   - Prepare offline exercises if needed

2. **Internet Connectivity Issues**:
   - Provide offline-capable exercises
   - Share mobile hotspot information
   - Have downloadable resources ready

3. **Platform Technical Issues**:
   - Test all features 1 hour before workshop
   - Have backup communication method
   - Keep technical support contact ready

---

## Post-Workshop Activities

### Immediate Follow-Up (Within 24 hours)

**Feedback Collection**:
```markdown
## Workshop 2 Feedback Form

### Technical Content
1. How would you rate the technical depth? (1-5)
2. Were the hands-on exercises valuable? (Yes/No)
3. What topics need more coverage?

### Delivery Format
1. Was the pace appropriate? (Too fast/Just right/Too slow)
2. Did you have enough time for exercises? (Yes/No)
3. How was the instructor support? (1-5)

### Next Steps
1. What will you implement first in your organization?
2. What additional learning resources do you need?
3. Would you recommend this workshop to colleagues? (Yes/No)
```

### Resource Sharing

**Comprehensive Resource Package**:
- [ ] All lab code and configurations
- [ ] Additional reference examples
- [ ] Troubleshooting guide
- [ ] Links to official documentation
- [ ] Community resources and forums

### Continued Learning Path

**30-Day Learning Plan**:
```markdown
## Week 1: Practice and Exploration
- [ ] Complete any unfinished lab exercises
- [ ] Explore additional Azure Verified Modules
- [ ] Set up personal development environment

## Week 2: Real Project Implementation
- [ ] Identify pilot project for IaC implementation
- [ ] Create project structure and initial configurations
- [ ] Set up CI/CD pipeline

## Week 3: Advanced Features
- [ ] Implement cross-region deployments
- [ ] Add security scanning and compliance checks
- [ ] Explore Terraform Cloud features

## Week 4: Team Enablement
- [ ] Share knowledge with team members
- [ ] Establish team coding standards
- [ ] Plan organization-wide IaC adoption
```

### Success Metrics

**Workshop Effectiveness Indicators**:
- 90%+ participants complete all core exercises
- 85%+ satisfaction rating
- 70%+ implement IaC practices within 30 days
- 50%+ report improved deployment processes

**Long-Term Impact Measures**:
- Reduction in manual infrastructure provisioning
- Decreased environment inconsistencies
- Improved deployment reliability
- Faster time-to-market for new projects

---

## Instructor Notes and Tips

### Teaching Techniques

**Code Demonstration Best Practices**:
- Use large fonts (minimum 14pt) for code
- Explain each line as you type
- Show errors intentionally and fix them
- Use consistent indentation and formatting

**Interactive Engagement**:
- Ask "Does everyone see this output?" frequently
- Use polls for technical checkpoints
- Encourage questions throughout, not just at the end
- Share screen often, but don't dominate

### Technical Expertise Areas

**Deep Knowledge Required**:
- Terraform state management and troubleshooting
- Azure networking and security best practices
- CI/CD pipeline patterns and anti-patterns
- Infrastructure cost optimization strategies

**Common Advanced Questions**:
- How to handle sensitive data in pipelines?
- What's the best way to structure large Terraform projects?
- How to handle Terraform state in team environments?
- When should we create custom modules vs using AVM?

### Workshop Adaptation Strategies

**For Different Audiences**:

**DevOps Engineers**:
- Focus more on pipeline automation
- Deep dive into state management
- Discuss enterprise governance patterns

**Software Developers**:
- Emphasize integration with application deployment
- Show local development workflows
- Connect IaC to software development lifecycle

**IT Managers**:
- Highlight cost and risk reduction benefits
- Discuss organizational change management
- Focus on compliance and governance aspects

---

**Conclusion**: This facilitator guide provides the framework for delivering an effective, hands-on Infrastructure as Code workshop. The key to success is balancing technical depth with practical applicability while providing robust support for participants at different skill levels.

Remember: The goal is not just to teach tools, but to enable participants to successfully implement Infrastructure as Code practices in their real-world environments.
