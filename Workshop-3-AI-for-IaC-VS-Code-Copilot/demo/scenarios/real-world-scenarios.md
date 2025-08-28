# Real-World Scenarios for AI-Assisted Development

These scenarios provide realistic contexts for practicing AI-assisted Terraform development during Workshop 3.

## Scenario 1: E-commerce Platform Migration

### Business Context
**Company**: GlobalRetail Inc.  
**Challenge**: Migrating legacy e-commerce platform to Azure  
**Timeline**: 90 days  
**Budget**: $8,000/month operational costs  

### Current State
- **Frontend**: Angular application on Windows Server 2016
- **Backend**: .NET Core 3.1 APIs on Windows Server 2016
- **Database**: SQL Server 2017 Standard (2TB)
- **Traffic**: 25,000 daily active users, peak 500 concurrent
- **Compliance**: PCI DSS Level 2 required

### Migration Requirements
- **Performance**: 99.9% availability SLA
- **Security**: Zero-downtime deployment capability
- **Scalability**: Handle Black Friday 10x traffic spikes
- **Integration**: Existing Azure AD B2C for authentication
- **Data**: Maintain data residency in East US

### AI Assistance Prompts

**Architecture Discovery Prompt**:
```
Chat Prompt: "I'm migrating an e-commerce platform from on-premises to Azure. 
Current: Angular frontend, .NET Core APIs, SQL Server 2017, 25K daily users, PCI compliance required.
Requirements: 99.9% availability, 10x Black Friday scaling, $8K/month budget, East US region.
Recommend optimal Azure architecture with cost justification."
```

**Infrastructure Generation Prompt**:
```terraform
// E-commerce platform infrastructure for GlobalRetail Inc.
// Requirements:
// - Angular frontend (SPA)
// - .NET Core 3.1 APIs  
// - SQL Server database with 2TB data
// - PCI DSS compliance
// - Auto-scaling for 10x traffic spikes
// - 99.9% availability SLA
// - $8,000/month budget target
// - East US region
//
// Generate complete Terraform configuration
```

### Expected Learning Outcomes
- Practice constraint-based prompting
- Experience iterative architecture refinement
- Learn compliance integration with AI assistance
- Understand cost optimization through AI consultation

---

## Scenario 2: SaaS Application Development

### Business Context
**Company**: DataInsights Pro  
**Product**: Multi-tenant analytics SaaS platform  
**Stage**: MVP to production scaling  
**Growth Target**: 1,000 customers in 12 months  

### Technical Requirements
- **Multi-tenancy**: Isolated data per customer
- **API-First**: RESTful APIs for third-party integrations
- **Real-time**: WebSocket connections for live dashboards
- **Data Processing**: ETL pipelines for customer data
- **Analytics**: Machine learning model serving

### Operational Requirements
- **DevOps**: CI/CD with multiple environment stages
- **Monitoring**: Comprehensive observability
- **Security**: SOC 2 Type II compliance preparation
- **Backup**: Point-in-time recovery for customer data
- **Scaling**: Automatic scaling based on tenant usage

### AI Assistance Prompts

**Multi-tenant Architecture Prompt**:
```
Chat Prompt: "Design Azure architecture for multi-tenant SaaS analytics platform:
- 1,000+ customers with isolated data
- Real-time dashboards with WebSocket
- ETL data processing pipelines
- ML model serving capabilities  
- SOC 2 compliance requirements
- Auto-scaling per tenant usage
Provide tenant isolation strategy and infrastructure design."
```

**DevOps Pipeline Prompt**:
```yaml
# Complete CI/CD pipeline for multi-tenant SaaS platform
# Requirements:
# - Dev/Staging/Production environments
# - Per-tenant deployment capabilities  
# - Automated testing including security scans
# - SOC 2 compliance validation
# - Zero-downtime deployments
# - Rollback capabilities
#
# Generate Azure DevOps pipeline configuration
```

### Expected Learning Outcomes
- Master complex architectural prompting
- Learn multi-tenant infrastructure patterns
- Practice compliance-aware development
- Understand AI assistance for DevOps automation

---

## Scenario 3: Healthcare Data Platform

### Business Context
**Organization**: Regional Healthcare Network  
**Project**: Patient data analytics platform  
**Compliance**: HIPAA, HITECH, state privacy laws  
**Scale**: 500,000 patient records, 50 facilities  

### Technical Architecture
- **Data Ingestion**: HL7 FHIR message processing
- **Storage**: Encrypted data lake with structured/unstructured data
- **Analytics**: Population health analytics and reporting
- **Integration**: Epic EHR system integration
- **Security**: End-to-end encryption, audit logging

### Regulatory Requirements
- **HIPAA**: Business Associate Agreement compliance
- **Encryption**: Data at rest and in transit
- **Access Control**: Role-based with audit trails
- **Data Retention**: 7-year minimum retention policy
- **Incident Response**: Breach notification procedures

### AI Assistance Prompts

**HIPAA-Compliant Architecture Prompt**:
```
Chat Prompt: "Design Azure architecture for healthcare data analytics platform:
- 500K patient records from 50 facilities
- HL7 FHIR message ingestion
- HIPAA/HITECH compliance required
- Epic EHR system integration
- Population health analytics
- End-to-end encryption mandatory
- Role-based access with audit trails
Provide security-first architecture with compliance validation."
```

**Security Configuration Prompt**:
```terraform
// Healthcare data platform infrastructure
// CRITICAL REQUIREMENTS:
// - HIPAA compliance mandatory
// - All data encrypted at rest and in transit
// - Network isolation and private endpoints
// - Comprehensive audit logging
// - Role-based access control (RBAC)
// - Automated backup and disaster recovery
// - Incident response capabilities
//
// Generate secure, compliant Terraform configuration
```

### Expected Learning Outcomes
- Practice compliance-first prompting techniques
- Learn healthcare-specific Azure services
- Master security-focused AI consultation
- Understand regulatory constraint integration

---

## Scenario 4: Financial Services Platform

### Business Context
**Company**: FinTech Innovations  
**Product**: Digital banking platform  
**Regulatory**: PCI DSS Level 1, SOX compliance  
**Scale**: 100,000 active accounts, $1B+ transaction volume  

### System Components
- **Core Banking**: Account management and transactions
- **Payment Processing**: Card and ACH payment processing
- **Risk Management**: Real-time fraud detection
- **Reporting**: Regulatory reporting and analytics
- **Customer Portal**: Web and mobile applications

### Compliance Requirements
- **PCI DSS**: Level 1 merchant compliance
- **SOX**: Financial reporting controls
- **KYC/AML**: Customer identity verification
- **Data Residency**: US-based data processing
- **Audit**: Immutable audit trails

### AI Assistance Prompts

**Financial Services Architecture Prompt**:
```
Chat Prompt: "Design Azure architecture for digital banking platform:
- 100K accounts, $1B+ transaction volume
- PCI DSS Level 1 compliance required
- Real-time fraud detection system
- Core banking with payment processing
- SOX compliance for financial reporting
- KYC/AML customer verification
- US data residency requirements
Recommend secure, compliant, high-performance architecture."
```

**PCI Compliance Prompt**:
```terraform
// Digital banking platform infrastructure
// PCI DSS Level 1 COMPLIANCE REQUIRED:
// - Card data environment (CDE) isolation
// - Network segmentation and monitoring
// - Encrypted payment processing
// - Access control and authentication
// - Vulnerability management
// - Regular security testing
// - Incident response procedures
//
// Generate PCI-compliant Terraform configuration
```

### Expected Learning Outcomes
- Master financial services compliance prompting
- Learn high-security architecture patterns
- Practice regulatory constraint integration
- Understand payment processing infrastructure

---

## Scenario Usage Guidelines

### For Facilitators

#### Scenario Selection Strategy
- **Session 1**: Use Scenario 1 (E-commerce) - familiar domain for most participants
- **Session 2**: Choose Scenario 2 or 3 based on participant backgrounds
- **Session 3**: Use Scenario 4 for advanced compliance discussion
- **Flexibility**: Have all scenarios ready and adapt based on participant interest

#### Facilitation Tips
1. **Context Setting**: Spend 5 minutes establishing business context
2. **Role Assignment**: Have participants assume relevant roles
3. **Progressive Disclosure**: Reveal requirements gradually
4. **Real-world Connection**: Connect to participants' actual work scenarios

#### Assessment Integration
- Use scenarios for both practice and assessment
- Encourage teams to present their architectural decisions
- Compare AI-generated solutions across teams
- Discuss trade-offs and alternative approaches

### For Participants

#### Approach Strategy
1. **Understand Business Context**: Read scenario thoroughly before prompting
2. **Iterative Development**: Start with high-level architecture, then drill down
3. **Constraint Integration**: Include all requirements in your prompts
4. **Validation**: Question and validate all AI suggestions
5. **Documentation**: Document your prompting strategies and results

#### Learning Maximization
- Try different prompting approaches for the same scenario
- Compare your results with teammates
- Challenge AI suggestions and ask for alternatives
- Focus on understanding architectural decisions, not just code generation

---

## Extension Scenarios

### Quick Practice Scenarios (15-20 minutes)
- **IoT Platform**: Sensor data ingestion and processing
- **Content Management**: Media streaming and CDN
- **Gaming Backend**: Real-time multiplayer game infrastructure
- **Data Science Platform**: ML model training and serving

### Advanced Challenge Scenarios (45-60 minutes)
- **Hybrid Cloud**: Azure + on-premises integration
- **Global Platform**: Multi-region deployment with data sovereignty
- **Legacy Migration**: Mainframe to cloud transformation
- **Disaster Recovery**: Cross-region backup and failover

---

**Next Steps**: Choose a scenario that matches your learning objectives and begin practicing AI-assisted infrastructure development!
