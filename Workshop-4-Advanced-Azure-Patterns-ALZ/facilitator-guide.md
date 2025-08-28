# Workshop 4 Facilitator Guide

## Overview

**Workshop Title**: Advanced Azure Patterns—ALZ & Production IaC  
**Duration**: 4 hours  
**Target Audience**: Advanced engineers, operations teams, and cloud architects  
**Prerequisites**: Azure fundamentals, Terraform intermediate knowledge, enterprise cloud experience

---

## Workshop Structure & Timing

### Session Timeline

| **Time** | **Duration** | **Activity** | **Format** | **Key Focus** |
|----------|--------------|--------------|------------|---------------|
| 9:00-9:30 | 30 min | Welcome & Introductions | Interactive | Participant backgrounds, expectations |
| 9:30-10:15 | 45 min | Module 1: ALZ Fundamentals | Presentation | Enterprise architecture patterns |
| 10:15-10:30 | 15 min | Break | - | Networking |
| 10:30-11:15 | 45 min | Module 2: Terraform AVM Implementation | Presentation | Practical implementation |
| 11:15-12:00 | 45 min | Lab 1: ALZ Foundation Deployment | Hands-on | Management groups & policies |
| 12:00-1:00 | 60 min | Lunch Break | - | - |
| 1:00-1:30 | 30 min | Module 3: Module Registry & Version Management | Presentation | Enterprise governance |
| 1:30-2:15 | 45 min | Module 4: Policy as Code & Enterprise Pipelines | Presentation | Production operations |
| 2:15-2:30 | 15 min | Break | - | - |
| 2:30-3:15 | 45 min | Lab 2: Platform Services Implementation | Hands-on | Management & connectivity |
| 3:15-3:45 | 30 min | Lab 3: Landing Zone Implementation | Hands-on | Workload deployment |
| 3:45-4:00 | 15 min | Wrap-up & Q&A | Discussion | Next steps, resources |

---

## Pre-Workshop Preparation

### Facilitator Preparation Checklist

**Technical Setup (Complete 1 week before)**:
- [ ] **Azure Environment**: Ensure access to subscription with Management Group Contributor permissions
- [ ] **Demo Environment**: Pre-deploy complete ALZ scaffold for demonstrations
- [ ] **Lab Environment**: Validate all lab scripts and Terraform configurations  
- [ ] **Terraform Modules**: Verify all referenced Azure Verified Modules are available and current
- [ ] **Tools Testing**: Test all CLI tools, scripts, and automation on target environment

**Content Preparation**:
- [ ] **Slide Deck**: Review and customize presentation materials for audience
- [ ] **Lab Guides**: Print/distribute lab instructions and validation scripts
- [ ] **Demo Scripts**: Prepare live demonstration scenarios with backup recordings
- [ ] **Q&A Bank**: Review common questions and prepare detailed answers
- [ ] **Resource Links**: Prepare curated list of additional learning resources

**Participant Communication (Send 1 week before)**:
```
Subject: Workshop 4 Preparation - Advanced Azure Patterns & ALZ

Dear Workshop Participants,

Thank you for registering for Workshop 4: Advanced Azure Patterns—ALZ & Production IaC.

REQUIRED PREPARATION:
1. Install Azure CLI (latest version)
2. Install Terraform 1.5+ 
3. Ensure Azure subscription access with contributor permissions
4. Review ALZ reference architecture: https://aka.ms/ALZ

WHAT TO BRING:
- Laptop with admin rights for tool installation
- Azure credentials for hands-on labs
- Questions about your organization's cloud architecture

MATERIALS PROVIDED:
- Complete lab environment and scripts
- Reference architectures and best practices
- Enterprise-grade Terraform modules and examples

We look forward to an engaging session!

Best regards,
[Facilitator Name]
```

### Environment Prerequisites

**Azure Subscription Requirements**:
```yaml
required_permissions:
  - scope: "/providers/Microsoft.Management/managementGroups/{tenantId}"
    roles:
      - "Management Group Contributor"
      - "Policy Contributor"
  
  - scope: "/subscriptions/{subscriptionId}"
    roles:
      - "Contributor"
      - "User Access Administrator"

resource_quotas:
  - resource_type: "Microsoft.Management/managementGroups"
    limit_required: 15
  - resource_type: "Microsoft.Network/virtualNetworks"
    limit_required: 5
  - resource_type: "Microsoft.Storage/storageAccounts"
    limit_required: 10

regions:
  primary: "East US"
  secondary: "West US 2"
  allowed: ["East US", "West US 2", "Central US"]
```

---

## Module Delivery Guidelines

### Module 1: ALZ Fundamentals (45 minutes)

**Learning Objectives Validation**:
- Participants can explain the ALZ reference architecture components
- Participants understand management group hierarchy design principles
- Participants can identify appropriate governance patterns for their organization

**Delivery Structure**:

**Opening (10 minutes)**:
```
🎯 Engagement Hook:
"Show of hands: How many of you have deployed resources that later became 
'technical debt' because they didn't follow enterprise standards?"

📊 Context Setting:
- ALZ addresses the most common enterprise cloud challenges
- Reference architecture used by thousands of organizations
- Proven patterns that scale from startup to Fortune 500
```

**Core Content (25 minutes)**:

**Design Principles Deep Dive**:
- **Interactive Poll**: "What's your biggest challenge with cloud governance?"
- **Visual Architecture Walkthrough**: Use interactive diagrams
- **Real-world Examples**: Show actual enterprise implementations (anonymized)

**Management Group Strategy**:
```
💡 Facilitator Tip: Use the "Pizza Box" analogy
- Tenant Root = Building
- Management Groups = Floors  
- Subscriptions = Offices
- Resource Groups = Desks
- Resources = Equipment

This helps participants visualize hierarchy and inheritance.
```

**Policy Framework Discussion**:
- **Case Study**: Walk through a real policy violation scenario
- **Group Exercise**: Have teams design policy assignments for their org
- **Best Practice**: Explain the "progressive security" approach

**Wrap-up (10 minutes)**:
- **Knowledge Check**: Quick quiz on key concepts
- **Preview**: Connect to next module's technical implementation

**Common Questions & Answers**:

*Q: "How do we handle existing subscriptions that don't fit the ALZ model?"*
A: ALZ provides migration patterns. You can gradually move subscriptions into the appropriate management groups using the "brownfield" deployment approach. The key is to start with new workloads and migrate existing ones during their next major update cycle.

*Q: "What's the difference between ALZ and other landing zone approaches?"*  
A: ALZ is Microsoft's official reference architecture, tested with thousands of customers. It provides specific guidance for Azure services, while other approaches may be more generic. ALZ also includes detailed implementation patterns and automation.

### Module 2: Terraform AVM Implementation (45 minutes)

**Learning Objectives Validation**:
- Participants can implement management groups using Terraform
- Participants understand AVM module selection and usage patterns
- Participants can deploy core ALZ policies with proper inheritance

**Delivery Structure**:

**AVM Introduction (15 minutes)**:
```
🔍 Demonstration Script:
1. Show live Azure Verified Modules registry
2. Navigate through module categories (res, ptn, utl)
3. Demonstrate module documentation and examples
4. Show version history and community contributions

💡 Key Messages:
- AVM modules are production-ready and community-tested
- Consistent interface patterns across all modules
- Regular updates and security patches
- Enterprise support available through Microsoft
```

**Implementation Patterns (20 minutes)**:

**Live Coding Session**:
```terraform
# Start with basic example, build complexity
# Talk through each section as you type

# 1. Provider configuration
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

# 2. Management group creation
# Explain inheritance and dependency management

# 3. Policy assignment  
# Show different assignment patterns and scopes
```

**Best Practices Discussion (10 minutes)**:
- **Module composition patterns**: Show how to combine multiple AVM modules
- **State management strategies**: Discuss separation of concerns
- **Version pinning approaches**: Explain semantic versioning impact

**Interactive Elements**:
- **Code Review**: Have participants identify issues in sample code
- **Architecture Discussion**: Groups design their module structure
- **Troubleshooting**: Walk through common deployment errors

### Module 3: Module Registry & Version Management (30 minutes)

**Learning Objectives Validation**:
- Participants understand enterprise module registry strategies  
- Participants can implement semantic versioning for infrastructure
- Participants know how to establish quality gates and testing

**Delivery Approach**:

**Registry Strategy (15 minutes)**:
```
🏗️ Enterprise Scenario:
"Your organization has 50+ development teams. Each team is creating 
their own Terraform modules. How do you ensure consistency, security, 
and maintainability across all teams?"

Solution Framework:
1. Centralized registry with approval workflows
2. Automated testing and security scanning
3. Version management with deprecation policies
4. Consumer impact management
```

**Quality Assurance (15 minutes)**:
- **Demo**: Show automated testing pipeline in action
- **Case Study**: Walk through a module update that introduced breaking changes
- **Group Exercise**: Design quality gates for participant organizations

### Module 4: Policy as Code & Enterprise Pipelines (45 minutes)

**Learning Objectives Validation**:
- Participants can design policy as code workflows
- Participants understand multi-environment deployment strategies
- Participants can implement compliance automation and monitoring

**Key Delivery Points**:

**Policy as Code Framework (20 minutes)**:
```
🎯 Real-world Challenge:
"Your compliance team needs to ensure all storage accounts have 
encryption enabled, but developers keep forgetting. How do you 
automate this without blocking development velocity?"

Progressive Solution:
1. Start with Audit policies (visibility)
2. Move to DeployIfNotExists (automated remediation) 
3. Finally Deny policies (prevention) for critical controls
```

**Enterprise Pipeline Design (25 minutes)**:
- **Architecture Walkthrough**: Multi-stage deployment patterns
- **Security Integration**: Show security scanning in pipelines
- **Governance Controls**: Demonstrate approval workflows
- **Monitoring Integration**: Connect to alerting and compliance dashboards

---

## Lab Facilitation Guidelines

### Lab Setup and Support

**Pre-lab Checklist (15 minutes before each lab)**:
```bash
# Facilitator validation script
#!/bin/bash

echo "🔧 Pre-Lab Validation"

# Check Azure CLI connectivity
az account show || exit 1

# Verify Terraform installation  
terraform version || exit 1

# Test AVM module accessibility
curl -s https://registry.terraform.io/providers/Azure/azurerm/latest || exit 1

# Validate permissions
az role assignment list --assignee $(az account show --query user.name -o tsv) --scope "/providers/Microsoft.Management/managementGroups/$(az account show --query tenantId -o tsv)"

echo "✅ Environment ready for labs"
```

**Common Lab Issues & Solutions**:

**Issue 1: Management Group Permissions**
```
Symptoms: "Insufficient privileges" errors when creating management groups
Solution: 
1. Verify participant has Management Group Contributor at tenant root
2. Use alternative: create under existing management group 
3. Backup plan: Use shared demo environment for group exercises
```

**Issue 2: Terraform Backend Authentication**
```
Symptoms: Backend initialization fails with authentication errors
Solution:
1. Ensure `az login` is completed and subscription is set
2. Verify storage account exists and participant has access
3. Alternative: Use local backend for lab exercises
```

**Issue 3: Azure Policy Delays**
```
Symptoms: Policy assignments don't appear immediately in portal
Solution:
1. Explain Azure's eventual consistency model
2. Show CLI commands to verify policy state
3. Continue with next lab steps while policies propagate
```

### Lab Progression Monitoring

**Progress Checkpoints**:

**Lab 1 Checkpoint (20 minutes in)**:
```
✅ Expected State:
- Terraform initialization completed
- Management group hierarchy visible in portal
- At least one policy assignment created

🚨 Red Flags:
- Multiple participants stuck on same step
- Authentication/permission errors
- Terraform validation failures

🎯 Facilitator Actions:
- Address common issues with group explanation
- Pair struggling participants with successful ones
- Provide alternative approaches for blocked participants
```

**Lab 2 Checkpoint (30 minutes in)**:
```
✅ Expected State: 
- Hub network deployed with critical subnets
- Platform services (firewall, gateway) provisioned
- Network peering established

🎯 Support Strategy:
- Focus on participants who completed Lab 1 successfully
- Use "buddy system" for participants needing extra help
- Demonstrate key components on shared screen if needed
```

### Troubleshooting Guide

**Critical Error Response Protocol**:

**Terraform State Issues**:
```bash
# Quick fix script for state conflicts
terraform force-unlock <lock_id>
terraform refresh
terraform plan  # Verify state consistency
```

**Azure Resource Quota Errors**:
```bash
# Check quota status
az vm list-usage --location "East US" --query "[?currentValue >= limit]"

# Alternative approach: Use different resource SKUs
# Backup plan: Use pre-deployed shared resources
```

**Network Connectivity Issues**:
```bash
# Validate network deployment
az network vnet list --query "[].{Name:name, AddressSpace:addressSpace}"

# Check subnet configuration
az network vnet subnet list --vnet-name <vnet-name> --resource-group <rg-name>
```

---

## Assessment and Engagement Strategies

### Knowledge Validation Techniques

**Progressive Assessment**:

**Module 1 - Quick Poll**:
```
Questions (use interactive polling tool):
1. What is the primary purpose of the management group hierarchy?
   a) Organizing resources by team
   b) Policy inheritance and governance 
   c) Cost management
   d) Access control

2. Which ALZ design principle is most important for your organization?
   [Open response - creates discussion opportunities]
```

**Module 2 - Code Review Exercise**:
```terraform
# Present flawed code, have participants identify issues
resource "azurerm_management_group" "example" {
  name         = "my-mg"
  display_name = "My Management Group"
  # Missing: parent_management_group_id
  # Issue: Hard-coded naming
  # Problem: No dependency management
}
```

**Lab Validation - Peer Review**:
- Participants pair up to review each other's Terraform code
- Use structured checklist for code quality assessment
- Share interesting solutions with entire group

### Engagement Techniques

**Interactive Moments**:

**"Architecture Café" (15 minutes during Module 1)**:
- Participants move between stations with different ALZ scenarios
- Each station has a specific challenge to solve
- Groups rotate and build on previous group's solutions

**"Policy Workshop" (20 minutes during Module 4)**:
- Divide into teams representing different organizational roles:
  - Security team (wants strict policies)
  - Development team (wants flexibility)  
  - Operations team (wants reliability)
  - Business stakeholders (want cost control)
- Each team proposes policy framework
- Facilitate negotiation to reach consensus

**Real-world Connection Points**:
```
Throughout the workshop, consistently connect concepts to participant experiences:

"How does this compare to your current cloud governance approach?"
"What challenges would you face implementing this in your organization?"
"Who would need to be involved in this decision at your company?"
```

### Handling Diverse Experience Levels

**Advanced Participants**:
- Provide additional challenge exercises
- Ask them to mentor others during labs
- Engage them in architecture discussions and alternatives
- Share complex real-world scenarios for their input

**Less Experienced Participants**:
- Pair with more experienced participants
- Provide additional context and background explanations
- Focus on conceptual understanding over technical details
- Offer simplified lab alternatives if needed

**Mixed Groups Strategy**:
- Use "jigsaw" method: experts teach specific topics to others
- Create cross-functional teams for lab exercises
- Encourage knowledge sharing and peer learning

---

## Post-Workshop Activities

### Immediate Follow-up (Within 24 hours)

**Resource Package Email**:
```
Subject: Workshop 4 Resources & Next Steps

Thank you for participating in Advanced Azure Patterns - ALZ & Production IaC!

📦 RESOURCE PACKAGE:
- Complete lab code repository: [GitHub Link]
- ALZ reference architecture diagrams
- Production readiness checklist
- Enterprise pipeline templates
- Policy as Code starter kit

🎯 IMMEDIATE NEXT STEPS:
1. Complete the workshop evaluation survey: [Link]
2. Join our ALZ Community: [Teams/Slack Channel]
3. Schedule optional 1:1 consultation: [Calendly Link]

📚 RECOMMENDED LEARNING PATH:
- Microsoft Learn: ALZ Implementation Guide
- Azure Architecture Center: Enterprise-Scale Reference
- Terraform Azure Provider Documentation
- Azure Verified Modules Registry

🤝 COMMUNITY & SUPPORT:
- Monthly ALZ Office Hours: [Meeting Link]
- GitHub Discussions: [Repository Link] 
- LinkedIn Group: [Group Link]

Looking forward to hearing about your ALZ implementation journey!
```

**Evaluation Form**:
```
Workshop 4 Evaluation

CONTENT ASSESSMENT:
□ Module 1 (ALZ Fundamentals): Excellent | Good | Fair | Poor
□ Module 2 (Terraform AVM): Excellent | Good | Fair | Poor  
□ Module 3 (Module Registry): Excellent | Good | Fair | Poor
□ Module 4 (Policy as Code): Excellent | Good | Fair | Poor

LAB EXPERIENCE:
□ Lab difficulty level: Too Easy | Just Right | Too Hard
□ Lab instructions clarity: Very Clear | Clear | Unclear | Very Unclear
□ Technical environment: Excellent | Good | Fair | Poor

FACILITATOR EFFECTIVENESS:
□ Knowledge and expertise: [Rating 1-5]
□ Communication style: [Rating 1-5] 
□ Responsiveness to questions: [Rating 1-5]

OVERALL WORKSHOP:
□ Met your learning objectives: Completely | Mostly | Partially | Not at all
□ Would recommend to colleagues: Definitely | Probably | Might | No
□ Overall satisfaction: [Rating 1-5]

OPEN FEEDBACK:
- What was the most valuable part of the workshop?
- What could be improved?
- What additional topics would you like to see covered?
- How will you apply what you learned?
```

### Long-term Engagement (30/60/90 days)

**30-Day Check-in**:
- Email survey about implementation progress
- Offer technical support session for early adopters
- Share success stories from other participants

**60-Day Advanced Session**:
- Optional follow-up workshop on advanced topics:
  - Multi-cloud ALZ patterns
  - Advanced compliance frameworks
  - Enterprise DevOps integration
  - Cost optimization strategies

**90-Day Community Showcase**:
- Invite participants to present their implementations
- Create case study library
- Plan next workshop topics based on feedback

---

## Success Metrics & KPIs

### Workshop Effectiveness Metrics

**Immediate Metrics (Day 0)**:
- Participant satisfaction score: Target >4.2/5.0
- Lab completion rate: Target >85%
- Knowledge assessment improvement: Target >30%
- Net Promoter Score: Target >7

**Short-term Impact (30 days)**:
- Implementation initiation rate: Target >60%
- Community engagement: Target >40% join follow-up channels
- Additional resource usage: Target >50% access provided materials
- Follow-up consultation requests: Target 20-30%

**Long-term Impact (90 days)**:
- Production implementation rate: Target >25%
- Advanced workshop attendance: Target >30%
- Case study participation: Target 10-15 organizations
- Reference customer development: Target 3-5 customers

### Continuous Improvement Process

**Content Iteration**:
- Monthly review of participant feedback
- Quarterly update of technical content for new Azure features
- Annual comprehensive curriculum review
- Integration of latest ALZ patterns and best practices

**Facilitator Development**:
- Peer observation and feedback sessions
- Regular technical certification updates  
- Customer advisory board input on workshop effectiveness
- Integration of field experience into content delivery

---

## Emergency Protocols

### Technical Issues

**Complete Environment Failure**:
1. **Immediate Response** (5 minutes):
   - Switch to pre-recorded demo mode
   - Distribute alternative lab environment access
   - Continue with theoretical discussion while resolving

2. **Backup Environment Activation** (10 minutes):
   - Activate secondary Azure subscription
   - Provide participants with backup lab credentials
   - Resume hands-on activities

3. **Contingency Teaching** (Ongoing):
   - Use whiteboard architecture sessions
   - Group problem-solving exercises
   - Peer teaching and knowledge sharing

### Participant Issues

**Significant Knowledge Gap**:
- Pair with experienced participant for mentoring
- Provide simplified lab track with core concepts
- Schedule follow-up 1:1 session for additional support

**Disruptive Behavior**:
- Private conversation during break
- Refocus on collaborative learning objectives
- Engage in positive way through expert knowledge sharing

### Schedule Disruptions

**Running Behind Schedule**:
- Prioritize hands-on labs over theoretical content
- Use "parking lot" for detailed questions
- Provide extended self-study materials for missed content

**Technical Delays**:
- Use interactive architecture discussions
- Conduct group whiteboard exercises
- Share recorded demos while resolving issues

This comprehensive facilitator guide provides the structure and support needed to deliver an exceptional Workshop 4 experience that drives real business value and technical capability development.
