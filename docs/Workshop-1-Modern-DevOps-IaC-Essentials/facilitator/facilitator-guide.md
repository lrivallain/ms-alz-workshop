# Facilitator Guide - Modern DevOps & IaC Essentials Workshop

---

## Pre-Workshop Preparation

### Technical Setup (30 minutes before start)

- [ ] Test presentation equipment and screen sharing
- [ ] Verify internet connectivity for demonstrations
- [ ] Prepare Azure portal access for live demos
- [ ] Set up Terraform playground environment (if doing live coding)
- [ ] Test Mermaid diagram rendering in presentation tool

### Materials Checklist

- [ ] All markdown files accessible and formatted
- [ ] Exercise handouts printed (optional)
- [ ] Participant feedback forms ready
- [ ] Contact information for follow-up resources
- [ ] Workshop evaluation survey link

### Room Setup

- [ ] Seating arranged for group discussions
- [ ] Whiteboards/flipcharts available for exercises
- [ ] Power outlets accessible for laptops
- [ ] Break area identified and refreshments arranged

---

## Detailed Facilitation Guide

### Opening (5 minutes) - 9:00-9:05 AM

#### Welcome and Introductions

**Script**: "Good morning! Welcome to our Modern DevOps & Infrastructure as Code Essentials workshop. Over the next 2 hours, we'll explore how modern DevOps practices and Infrastructure as Code can transform how your teams deliver value to customers."

#### Quick Introductions

Go around the room (or use breakout rooms for virtual):

- Name and role
- One current infrastructure challenge
- What you hope to learn today

**Facilitator Notes**:

- Keep introductions brief (1 minute each)
- Note challenges mentioned for later reference
- Adjust technical depth based on audience mix

---

### Session 1: DevOps Principles & Value

#### Opening Hook

**Question**: "How long does it currently take your organization to deploy a simple code change to production?"

Record answers on whiteboard:

- Minutes: ___
- Hours: ___
- Days: ___
- Weeks: ___

#### Exercise: DevOps Maturity Assessment

**Instructions**:

1. Form pairs or triads
2. Complete the assessment table together
3. Identify lowest-scoring area
4. Brainstorm one quick win

#### Wrap-up and Transition

**Key Messages**:

- DevOps is about culture, not just tools
- Small improvements compound over time
- Measurement drives improvement

**Transition**: "Now let's explore how Infrastructure as Code supports these DevOps principles..."

---

### Session 2: Introduction to Infrastructure as Code

#### Opening Challenge

**Scenario**: "Imagine you need to create identical environments for 5 development teams by tomorrow morning. How would you approach this?"

Capture approaches:

- Manual setup: ___
- Scripts: ___
- Templates: ___
- IaC tools: ___

#### Core Content Delivery

##### What is IaC?

- **Visual**: Traditional vs. IaC approach diagram
- **Analogy**: "Like a recipe vs. cooking from memory"
- **Demo**: Show simple Terraform code vs. Azure portal clicks

##### Core Principles

- **Declarative**: "Describe what you want, not how to get it"
- **Version Control**: Show git commit history for infrastructure
- **Idempotency**: "Same input, same output, every time"

##### Tools Landscape

- **Visual**: Tool comparison chart
- **Guidance**: "Choose based on your needs, not popularity"
- **Azure Focus**: Position Terraform for multi-cloud, Bicep for Azure-pure

#### Exercise: IaC Benefits Analysis

**Instructions**:

1. Use the provided scenario
2. Compare manual vs. IaC approaches
3. Focus on business impact, not just technical benefits

**Facilitator Notes**:

- Circulate and help groups think beyond just "speed"
- Prompt for compliance, audit, cost considerations
- Collect interesting insights for group sharing

---

### Session 3: Source Control & Git Workflows

#### Opening Story

**War Story**: "A major company once lost $300M in revenue because a manual infrastructure change broke their production systems. Here's how proper version control could have prevented it..."

#### Core Content Delivery

##### Why Version Control for Infrastructure?

- **Visual**: Infrastructure timeline diagram
- **Key Point**: "Infrastructure changes are often riskier than code changes"
- **Examples**: Show infrastructure change gone wrong

##### Git Fundamentals

- **Interactive**: "Who has used Git for code? For infrastructure?"
- **Visual**: Git workflow diagram
- **Demo**: Show simple git commands for infrastructure code

##### Pull Request Workflow

- **Visual**: PR process sequence diagram
- **Real Example**: Show actual infrastructure PR with review comments
- **Best Practice**: Review checklist for infrastructure changes

#### Exercise: Git Workflow Simulation

**Part A - Branching Strategy**:

- Groups design branching strategy for given scenario
- Draw on whiteboard or paper

**Part B - Code Review**:

- Review sample Terraform code
- Identify security and quality issues

??? tip "Example of issues to find"

    - Hardcoded password (plain text)
        - This will be stored in state files, logs, and version control
        - Anyone with repository access can see the password
    - Naming conventions
    - No variable use:
        - what if I want to change the region for all the resources?
    - No tagging consistency
    - Modularity
    - ...

**Facilitator Actions**:

- Have groups share their branching strategies
- Highlight common review issues found

---

### BREAK (15 minutes)

---

### Session 4: What is Terraform?

#### Core Content Delivery

##### Terraform Concepts

- **Interactive**: "What's the difference between declarative and imperative?"
- **Visual**: Terraform workflow diagram
- **Hands-on**: Pass around printed Terraform code examples

##### State Management

- **Critical Point**: "State is Terraform's memory"
- **Visual**: State file role in Terraform process
- **Warning**: "Never edit state files manually"

##### Azure Integration

- **Demo**: Show Azure provider configuration
- **Examples**: Common Azure resources in Terraform
- **Best Practices**: Authentication methods

#### Exercise: First Terraform Configuration

**Group Exercise**:

1. Draw the architecture on a whiteboard or paper
2. Groups discuss and complete missing pieces
3. Discuss design decisions

**Facilitator Notes**:

- Expectations: resource names, variable usage, and tagging
- Help groups think about dependencies between resources
- Highlight good practices in group solutions

---

### Session 5: Reusable Modules & Azure Verified Modules

#### Opening Problem

**Question**: "How do you ensure consistency when 10 different teams need to deploy the same type of infrastructure?"

Collect approaches:

- Documentation: ___
- Copy/paste: ___
- Shared templates: ___
- Modules: ___

#### Core Content Delivery

##### Module Benefits

- **Visual**: Module architecture diagram
- **Analogy**: "Like functions in programming - reusable and testable"
- **Examples**: Show before/after with and without modules

##### Azure Verified Modules

- **Visual**: AVM initiative diagram
- **Demo**: Browse AVM modules in Terraform Registry
- **Value Prop**: "Microsoft-verified, production-ready modules"

##### Module Best Practices

- **Interface Design**: Simple but flexible
- **Security Defaults**: Secure by default
- **Documentation**: Makes modules usable by others

#### Exercise: Module Creation and Usage

**Structured Exercise**:

1. **Create Module (3 minutes)**: Groups outline database module structure
2. **Compare with AVM (2 minutes)**: Find similar AVM module and compare

**Facilitator Actions**:

- Provide guidance on module structure
- Help groups find appropriate AVM modules
- Facilitate comparison discussion

---

### Wrap-up and Q&A - 11:00-11:05 AM

#### Key Takeaways Summary

**Interactive**: "What's one thing you'll do differently after today?"

Go around room and collect:

- Immediate actions
- Biggest insights
- Remaining questions

#### Resources and Next Steps

**Handout**: Provide resource links and learning paths
- Azure Verified Modules website
- Terraform learning materials
- Community resources

#### Final Q&A (1 minute)

**Open Floor**: Address any remaining questions

---

**End of Facilitator Guide**
