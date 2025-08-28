# Effective Prompts and Techniques for AI-Assisted Terraform Development

This collection contains proven prompts, techniques, and strategies for maximizing AI effectiveness in infrastructure as code development.

## Table of Contents
- [SMART Prompting Framework](#smart-prompting-framework)
- [Context-Building Techniques](#context-building-techniques)
- [Advanced Prompting Strategies](#advanced-prompting-strategies)
- [Security-Focused Prompts](#security-focused-prompts)
- [Compliance and Governance](#compliance-and-governance)
- [Troubleshooting and Debugging](#troubleshooting-and-debugging)

---

## SMART Prompting Framework

### Template: SMART Infrastructure Prompt
```
# SMART Prompting Template for Infrastructure Projects

## SPECIFIC
- **System Type**: [web application/data platform/API service/etc.]
- **Core Components**: [specific services and technologies]
- **Integration Points**: [existing systems, third-party services]

## MEASURABLE  
- **Performance Requirements**: [users, transactions, response times]
- **Availability Target**: [SLA percentage, downtime tolerance]
- **Scale Metrics**: [growth projections, peak usage patterns]

## ACTIONABLE
- **Technical Constraints**: [technology stack, existing infrastructure]
- **Operational Requirements**: [deployment, monitoring, maintenance]
- **Integration Needs**: [APIs, databases, external services]

## RELEVANT
- **Compliance Requirements**: [industry standards, regulations]
- **Security Constraints**: [data classification, access controls]
- **Business Context**: [industry, use case, criticality]

## TIME-BOUND
- **Deployment Timeline**: [phases, milestones, deadlines]
- **Budget Constraints**: [cost targets, optimization priorities]
- **Resource Availability**: [team capacity, expertise levels]

Generate Terraform configuration that addresses all specified requirements.
```

### Example: E-commerce Platform SMART Prompt
```
Chat Prompt: "Design Azure infrastructure using SMART framework:

SPECIFIC: E-commerce platform with React frontend, Node.js APIs, PostgreSQL database
- Product catalog and search
- Payment processing integration  
- Order management system
- Customer authentication (Azure AD B2C)

MEASURABLE: 
- 50,000 daily active users
- 99.9% uptime SLA
- 2-second page load times
- 10,000 concurrent users during peak (Black Friday)

ACTIONABLE:
- Microservices architecture preferred
- CI/CD with GitHub Actions
- Multi-environment deployment (dev/staging/prod)
- Auto-scaling capabilities required

RELEVANT:
- PCI DSS compliance for payment data
- GDPR compliance for EU customers  
- Cost optimization priority
- 24/7 operational requirements

TIME-BOUND:
- MVP in 8 weeks
- Production launch in 12 weeks
- $5,000/month operational budget
- 2-person DevOps team capacity

Provide complete Terraform infrastructure design with security best practices."
```

---

## Context-Building Techniques

### Progressive Context Building
```terraform
// Technique 1: Start with Business Context
// E-commerce platform infrastructure for GlobalRetail Inc.
// Business requirements:
// - B2B and B2C sales channels
// - International expansion planned
// - Seasonal traffic variations (3x during holidays)
// - Integration with existing ERP system

// Technique 2: Add Technical Context  
// Current architecture:
// - Monolithic .NET Framework application
// - SQL Server 2017 database
// - On-premises Windows servers
// - Plans to modernize with microservices

// Technique 3: Specify Constraints
// Migration constraints:
// - Zero-downtime requirement
// - $50,000 migration budget
// - 6-month timeline
// - Retain existing SQL Server data
// - Maintain PCI compliance throughout

// Generate modernization roadmap and initial infrastructure
```

### Domain-Specific Context Prompting
```
Healthcare Context Prompt:
"Healthcare data analytics platform context:
- Protected Health Information (PHI) processing
- HIPAA Business Associate Agreement required
- 500,000+ patient records
- Real-time clinical decision support
- Integration with Epic EHR system
- 99.99% availability for critical alerts

Design HIPAA-compliant Azure architecture with appropriate safeguards."

Financial Services Context Prompt:
"Digital banking platform context:
- PCI DSS Level 1 compliance mandatory
- Real-time fraud detection required
- $10B+ annual transaction volume
- SOX compliance for financial reporting
- Multi-factor authentication required
- Disaster recovery RTO: 4 hours, RPO: 15 minutes

Generate secure, compliant banking infrastructure."
```

---

## Advanced Prompting Strategies

### Constraint-Based Architecture Prompting
```
Advanced Constraint Prompt:
"Design Azure infrastructure with the following constraints:

HARD CONSTRAINTS (non-negotiable):
- Data must remain in EU regions only
- Maximum 100ms API response time
- Zero scheduled downtime tolerance
- SOC 2 Type II compliance required

SOFT CONSTRAINTS (optimize for):
- Minimize operational overhead
- Cost under €8,000/month
- Prefer managed services
- Automated security scanning

TRADE-OFF PRIORITIES:
1. Security and compliance (highest)
2. Performance and availability
3. Operational simplicity  
4. Cost optimization (lowest)

Generate infrastructure that respects all constraints and optimizes for priority order."
```

### Iterative Refinement Prompting
```
Step 1 - High-Level Architecture:
"Design high-level architecture for real-time data processing platform:
- 1M+ events per second ingestion
- Complex event processing and analytics
- Real-time dashboards and alerting
- Historical data retention (5 years)
- Global deployment across 3 regions

Provide architectural overview with Azure services selection rationale."

Step 2 - Detailed Implementation:
"Based on the previous architecture design, generate detailed Terraform configuration for:
- Event ingestion layer with auto-scaling
- Stream processing with fault tolerance
- Real-time analytics with sub-second latency
- Data storage with cost-optimized retention
- Monitoring and alerting infrastructure

Include security best practices and disaster recovery capabilities."

Step 3 - Optimization and Security:
"Review the infrastructure configuration and optimize for:
- Cost efficiency (target 30% reduction)
- Security hardening (implement zero-trust principles)  
- Operational excellence (automated deployment and monitoring)
- Performance tuning (minimize latency and maximize throughput)

Provide specific improvements and rationale for each change."
```

### Multi-Perspective Prompting
```
Architect Perspective:
"As a solutions architect, review this infrastructure design:
- Are the service selections optimal for the requirements?
- What architectural patterns are implemented?
- How does this scale with business growth?
- What are the potential failure points?"

Security Perspective:
"As a security architect, analyze this infrastructure:  
- What security vulnerabilities exist?
- Are security controls properly layered?
- How is the principle of least privilege implemented?
- What compliance gaps need addressing?"

Operations Perspective:
"As a platform engineer, evaluate this infrastructure:
- How complex is the operational overhead?
- Are monitoring and alerting comprehensive?
- What automation opportunities exist?
- How maintainable is this long-term?"
```

---

## Security-Focused Prompts

### Security-First Design Prompting
```
Security-First Prompt Template:
"Design Azure infrastructure with security as the primary concern:

THREAT MODEL:
- Primary threats: [data breach, DDoS, insider threats, etc.]
- Attack vectors: [web application, API, database, network]
- Data classification: [public, internal, confidential, restricted]

SECURITY CONTROLS:
- Identity and access management
- Network security and segmentation
- Data encryption (at rest and in transit)
- Monitoring and threat detection
- Incident response capabilities

COMPLIANCE REQUIREMENTS:
- [GDPR, HIPAA, PCI DSS, SOC 2, etc.]
- Audit and logging requirements
- Data residency constraints
- Retention policies

Generate security-hardened Terraform configuration with comprehensive controls."
```

### Zero-Trust Architecture Prompting
```
Zero-Trust Prompt:
"Implement zero-trust architecture principles for Azure infrastructure:

CORE PRINCIPLES:
- Never trust, always verify
- Assume breach mentality
- Least privilege access
- Comprehensive monitoring and analytics

IMPLEMENTATION REQUIREMENTS:
- Multi-factor authentication for all access
- Conditional access policies
- Network micro-segmentation
- Just-in-time (JIT) access
- Continuous compliance monitoring
- Identity-based security perimeter

APPLICATION CONTEXT:
- Multi-tier web application
- Internal and external users
- API integrations with partners
- Sensitive customer data processing

Generate zero-trust compliant infrastructure with appropriate security controls."
```

### Vulnerability Assessment Prompting
```
Security Review Prompt:
"Perform comprehensive security assessment of this Terraform configuration:

ASSESSMENT AREAS:
1. Network security (NSGs, firewalls, segmentation)
2. Identity and access management (RBAC, managed identities)
3. Data protection (encryption, key management)
4. Monitoring and logging (security events, audit trails)
5. Compliance controls (regulatory requirements)

SECURITY STANDARDS:
- Azure Security Benchmark
- CIS Azure Foundations Benchmark  
- NIST Cybersecurity Framework
- Industry-specific requirements

Provide:
- Identified vulnerabilities and risks
- Recommended remediation steps
- Priority ranking based on risk level
- Terraform code corrections"
```

---

## Compliance and Governance

### Regulatory Compliance Prompting
```
GDPR Compliance Prompt:
"Ensure GDPR compliance for Azure infrastructure hosting EU customer data:

GDPR REQUIREMENTS:
- Data protection by design and default
- Right to erasure (right to be forgotten)
- Data portability and access rights
- Breach notification (72-hour requirement)
- Privacy impact assessments
- Data Processing Records (Article 30)

TECHNICAL MEASURES:
- Pseudonymization and encryption
- Data minimization principles
- Automated deletion processes
- Audit trails and logging
- Geographic data restrictions

Generate compliant infrastructure with appropriate technical and organizational measures."

PCI DSS Compliance Prompt:
"Design PCI DSS Level 1 compliant infrastructure for payment processing:

PCI DSS REQUIREMENTS:
- Secure network architecture and configuration
- Cardholder data protection and encryption
- Vulnerability management program
- Strong access control measures
- Network monitoring and testing
- Information security policy

CARDHOLDER DATA ENVIRONMENT:
- Network segmentation from other systems
- Encrypted storage and transmission
- Access logging and monitoring
- Regular security testing
- Incident response procedures

Generate PCI-compliant Terraform configuration with appropriate controls."
```

### Governance and Policy Prompting
```
Azure Policy Integration Prompt:
"Implement governance controls using Azure Policy for organizational compliance:

GOVERNANCE REQUIREMENTS:
- Resource naming standards enforcement
- Cost management and budget controls
- Security baseline enforcement
- Compliance monitoring and reporting
- Resource provisioning controls

POLICY AREAS:
- Allowed resource types and regions
- Required tagging standards
- Security configuration baselines
- Network access controls
- Data classification and handling

Generate Terraform configuration with Azure Policy integration for automated governance."

Cost Governance Prompt:
"Implement cost management and optimization governance:

COST CONTROLS:
- Budget alerts and spending limits
- Resource right-sizing recommendations  
- Unused resource identification
- Reserved instance optimization
- Cost allocation and chargeback

MONITORING AND REPORTING:
- Daily cost monitoring
- Department/project cost allocation
- Trend analysis and forecasting
- Cost anomaly detection
- Regular optimization reviews

Generate infrastructure with comprehensive cost governance controls."
```

---

## Troubleshooting and Debugging

### Diagnostic Prompting
```
Infrastructure Troubleshooting Prompt:
"Diagnose and resolve Azure infrastructure issues:

PROBLEM DESCRIPTION:
- [Specific issue description]
- [Error messages or symptoms]  
- [When the issue started]
- [What changes were made recently]

CURRENT STATE:
- [Infrastructure configuration]
- [Resource states and health]
- [Monitoring and alert data]
- [Recent deployment history]

EXPECTED BEHAVIOR:
- [What should be happening]
- [Performance baselines]
- [Business impact of the issue]

Provide:
- Root cause analysis
- Step-by-step resolution plan
- Terraform configuration fixes
- Prevention measures"
```

### Performance Optimization Prompting
```
Performance Tuning Prompt:
"Optimize Azure infrastructure performance based on monitoring data:

PERFORMANCE ISSUES:
- High response times: [specific metrics]
- Resource utilization: [CPU, memory, network, storage]
- Bottlenecks identified: [specific components]
- User impact: [affected scenarios and user experience]

CURRENT CONFIGURATION:
- [Resource specifications and settings]
- [Network configuration and routing]
- [Database performance settings]
- [Caching and CDN configuration]

OPTIMIZATION GOALS:
- Target response times: [specific SLAs]
- Cost efficiency requirements
- Scalability improvements needed
- Availability and reliability targets

Generate optimized Terraform configuration with performance improvements."
```

### Migration and Modernization Prompting
```
Legacy Migration Prompt:
"Plan and execute migration from legacy infrastructure to Azure:

CURRENT STATE:
- Legacy system architecture: [detailed description]
- Technology stack: [versions, dependencies]
- Performance characteristics: [current baseline]
- Business continuity requirements: [downtime tolerance]

MODERNIZATION GOALS:
- Target architecture: [cloud-native, microservices, etc.]
- Technology updates: [language versions, frameworks]
- Scalability improvements: [specific requirements]
- Security enhancements: [current gaps to address]

MIGRATION CONSTRAINTS:
- Timeline: [phases and milestones]
- Budget: [total and monthly operational]
- Risk tolerance: [business impact limits]
- Team capabilities: [skills and capacity]

Provide:
- Migration strategy and phases
- Risk assessment and mitigation
- Terraform configurations for target state
- Testing and validation approach"
```

---

## AI Interaction Best Practices

### Effective AI Conversation Techniques
```
1. START WITH CONTEXT
"I'm working on [project type] for [industry/company size]. 
The main business goal is [objective].
Current constraints are [technical, budget, timeline].
My experience level with [technology] is [beginner/intermediate/advanced]."

2. BE SPECIFIC WITH REQUIREMENTS  
Instead of: "Create a web application infrastructure"
Use: "Create infrastructure for Node.js e-commerce web application with PostgreSQL database, Redis caching, supporting 10,000 concurrent users with 99.9% availability SLA"

3. REQUEST EXPLANATIONS
"Explain why you chose Azure App Service over Container Apps for this scenario"
"What are the trade-offs between these database options?"
"How does this configuration address the security requirements?"

4. ITERATE AND REFINE
"The previous suggestion works, but I need to optimize for cost. Can you modify to reduce monthly spending by 30%?"
"Add disaster recovery capabilities with RTO of 4 hours"
"Enhance security to meet SOC 2 Type II requirements"

5. VALIDATE AND QUESTION
"Review this configuration for security vulnerabilities"
"Are there any Azure Well-Architected Framework principles I'm missing?"
"What would happen if [specific component] fails?"
```

### Prompt Quality Checklist
```
Before submitting a prompt, verify:
□ Business context is clearly defined
□ Technical requirements are specific and measurable  
□ Constraints and limitations are explicitly stated
□ Success criteria are defined
□ Industry/compliance requirements are mentioned
□ Timeline and budget parameters are included
□ Preference for explanation and reasoning is requested
□ Specific areas for AI focus are highlighted
```

---

## Workshop Application

### Session 1: Basic Prompts
Use these foundational prompts to establish AI interaction patterns:
- Simple resource creation with context
- Basic architectural decision support
- Configuration validation requests

### Session 2: Advanced Techniques  
Apply sophisticated prompting strategies:
- SMART framework for complex architectures
- Constraint-based design optimization
- Multi-perspective analysis requests

### Session 3: Security Integration
Focus on security-aware prompting:
- Threat-model-based architecture design
- Compliance requirement integration
- Vulnerability assessment and remediation

### Session 4: Real-World Application
Combine all techniques for practical scenarios:
- End-to-end project prompting strategies
- Migration planning and execution
- Performance optimization and troubleshooting

---

**Remember**: Great prompts lead to great AI assistance. Invest time in crafting detailed, context-rich prompts for optimal results!
