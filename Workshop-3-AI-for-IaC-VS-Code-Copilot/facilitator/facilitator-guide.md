# Workshop 3 Facilitator Guide

## Workshop Overview

**Title**: AI for IaC—VS Code Copilot Agent Mode  
**Duration**: 4 hours  
**Target Audience**: Technical (engineers, architects, operators)  
**Maximum Participants**: 16-20 (optimal for hands-on activities)

---

## Pre-Workshop Preparation

### 48 Hours Before Workshop

**Technical Setup Verification**:
- [ ] Verify all participants have GitHub Copilot subscriptions
- [ ] Send pre-workshop setup email with installation instructions
- [ ] Test demo environment and all sample configurations
- [ ] Prepare backup GitHub accounts with Copilot access (if needed)

**Materials Preparation**:
- [ ] Download and test all demo resources
- [ ] Prepare printed reference materials (keyboard shortcuts, prompt examples)
- [ ] Set up shared screen/projector for demonstrations
- [ ] Test internet connectivity and bandwidth for AI tools

**Communication**:
- [ ] Send reminder email with agenda and prerequisites
- [ ] Share pre-work instructions (Lab 1 setup guide)
- [ ] Provide workshop Slack/Teams channel for Q&A
- [ ] Confirm attendance and dietary requirements

### Day of Workshop

**Room Setup**:
- [ ] Ensure reliable internet connection (critical for AI tools)
- [ ] Test audio/visual equipment
- [ ] Set up backup hotspots (AI tools are bandwidth-intensive)
- [ ] Prepare seating arrangement for collaborative work

**Technical Readiness**:
- [ ] Have backup laptops with Copilot configured
- [ ] Prepare troubleshooting resources
- [ ] Test all demo scenarios end-to-end
- [ ] Have alternative exercises ready if technical issues arise

---

## Session-by-Session Facilitation Guide

### Session 1: GitHub Copilot Fundamentals (60 minutes)

#### Opening (10 minutes)
**Welcome and Context Setting**:
```
"Welcome to AI for Infrastructure as Code. Today we'll explore how AI can accelerate and improve your Terraform development while maintaining security and quality standards.

Show of hands:
- Who has used GitHub Copilot before?
- Who considers themselves advanced in Terraform?
- Who is responsible for security/compliance in their organization?

This helps me adjust examples and pace appropriately."
```

**Learning Objectives Review**:
- Set clear expectations for what participants will achieve
- Emphasize practical, hands-on learning approach
- Address any concerns about AI replacing human expertise

#### Core Content Delivery (35 minutes)

**Demonstration Script - Basic Copilot**:
```terraform
// Live Demo Script 1: Basic Functionality
// Start with new file: demo-basic.tf

// 1. Show basic resource completion
// Type: resource "azurerm_
// Highlight: Multiple suggestions, navigation, acceptance

// 2. Show comment-to-code generation
// Create Azure resource group for web application in East US
// Demonstrate: How descriptive comments improve suggestions

// 3. Show pattern recognition
// After creating one resource, create similar resource
// Highlight: How Copilot learns from established patterns
```

**Interactive Moment - Copilot Chat**:
```
// Have participants open Copilot Chat and ask:
"Explain the difference between Azure App Service and Container Apps for hosting web applications"

// Debrief: Quality of response, follow-up questions, context awareness
```

**Teaching Tip**: Walk around the room during hands-on time. Look for participants struggling with setup and provide immediate assistance.

#### Hands-On Activity (10 minutes)
**Quick Win Exercise**:
- Participants create basic infrastructure with AI assistance
- Focus on getting everyone successful with basic functionality
- Celebrate early successes to build confidence

#### Wrap-Up and Transition (5 minutes)
**Key Points Reinforcement**:
- AI is an assistant, not a replacement for expertise
- Context and prompting quality significantly impact results
- Preview Session 2 advanced techniques

---

### Session 2: AI-Powered Terraform Development (75 minutes)

#### Session Opening (10 minutes)
**Energy Check and Recap**:
```
"Quick pulse check - how did the basic Copilot experience feel? 
Any surprises or 'wow' moments?

Today we're moving from basic assistance to advanced techniques. 
We'll build complete infrastructure using AI as a force multiplier."
```

#### Advanced Techniques Demonstration (25 minutes)

**Demo Script - Advanced Prompting**:
```terraform
// Live Demo Script 2: Advanced Prompting
// File: advanced-demo.tf

// SMART Prompting Example
// SPECIFIC: E-commerce platform infrastructure
// MEASURABLE: 10,000 concurrent users, 99.9% uptime
// ACTIONABLE: Include auto-scaling, monitoring, disaster recovery
// RELEVANT: PCI compliance for payment processing
// TIME-BOUND: Production deployment in 60 days
//
// Budget: $5,000/month maximum
// Region: East US (data residency requirement)
// Integration: Existing Azure AD B2C
//
// Generate complete infrastructure for this e-commerce platform
```

**Teaching Moments**:
- **Pause frequently** to explain AI decision-making
- **Show alternatives** - demonstrate how different prompts yield different results
- **Highlight patterns** - point out when AI recognizes and extends patterns
- **Address mistakes** - show how to correct and improve AI suggestions

#### Guided Lab Activity (30 minutes)

**Three-Tier Architecture Build**:
- Divide participants into pairs for collaborative development
- Assign different scenarios (e-commerce, SaaS, data analytics)
- Circulate to provide guidance and capture interesting examples

**Facilitation Tips**:
- Every 10 minutes, ask for brief progress updates
- Share interesting discoveries across teams
- Help struggling teams with more specific prompts
- Document good examples for later sharing

#### Group Discussion and Sharing (10 minutes)
**Structured Sharing**:
```
"Let's hear from each team:
1. What infrastructure did you build?
2. What AI technique worked best for you?
3. What challenge did you encounter?
4. One thing you learned that surprised you?"
```

---

### Break (15 minutes)
**Break Management**:
- Encourage participants to keep VS Code/Copilot open
- Suggest they experiment during break
- Address any technical issues that arose
- Prepare for advanced session

---

### Session 3: Advanced AI Techniques & Best Practices (60 minutes)

#### Advanced Techniques Deep Dive (25 minutes)

**Demo Script - Prompt Engineering Mastery**:
```
// Constraint-Based Prompting Demo
Chat Prompt: "I need architecture advice for migrating a legacy application:

Current State:
- Windows Server 2012 R2
- IIS + ASP.NET 4.8
- SQL Server 2014
- 500GB database
- 50,000 monthly users

Requirements:
- 30% cost reduction
- Improved security posture
- 99.9% availability SLA
- PCI compliance
- Zero-downtime migration

Provide Azure migration strategy with Terraform configuration."
```

**Teaching Focus**:
- Demonstrate **iterative refinement** of AI responses
- Show how **constraints improve AI suggestions**
- Illustrate **architectural decision-making with AI guidance**
- Emphasize **human judgment in evaluating AI recommendations**

#### Advanced Workshop Activity (25 minutes)

**Migration Challenge**:
- Present legacy system scenario
- Teams use AI to design migration approach
- Focus on architectural decisions and trade-offs
- Encourage AI consultation for complex decisions

**Facilitation Strategy**:
- Move between teams as "AI consultant"
- Ask probing questions about AI recommendations
- Encourage teams to challenge AI suggestions
- Capture examples of good human-AI collaboration

#### Advanced Techniques Synthesis (10 minutes)
**Key Insights Discussion**:
- What patterns emerged in successful AI consultations?
- When did human expertise prove most critical?
- How can teams establish effective AI-assisted workflows?

---

### Session 4: Security, Compliance & Limitations (50 minutes)

#### Security Implications (20 minutes)

**Security Review Demo**:
```terraform
// Present intentionally vulnerable configuration
// Live security analysis using AI assistance
// Demonstrate automated scanning integration
// Show step-by-step remediation process

// Key Teaching Moments:
// 1. AI can suggest insecure patterns
// 2. Automated scanning catches many issues
// 3. Human review remains essential
// 4. Security-first prompting improves outcomes
```

**Interactive Security Exercise**:
- Provide vulnerable configurations to teams
- Teams identify and remediate security issues
- Use both AI assistance and automated tools
- Compare findings and remediation approaches

#### Compliance and Policy Development (15 minutes)

**Policy Workshop**:
```
Group Exercise: "Your organization is adopting AI for infrastructure development.

Working in small groups, develop:
1. AI usage guidelines for your team
2. Security review process for AI-generated code
3. Training requirements for team members
4. Success metrics for secure AI usage

Present one key policy recommendation to the group."
```

#### Limitations and Responsible Usage (15 minutes)

**Limitations Discussion**:
- **Technical limitations**: Context windows, version lag, platform nuances
- **Decision-making limitations**: Business context, cost optimization, architectural trade-offs
- **Security limitations**: Insecure training data, context misunderstanding

**Responsible Usage Framework**:
```
"The VALIDATE Framework for AI-Assisted Development:

V - Verify all AI suggestions against requirements
A - Analyze security implications thoroughly  
L - Leverage automated scanning and testing
I - Implement proper review processes
D - Document AI assistance for audit trails
A - Apply human expertise for complex decisions
T - Test comprehensively before deployment
E - Establish ongoing monitoring and improvement"
```

---

## Workshop Wrap-up (10 minutes)

### Summary and Action Items
**Key Takeaways Reinforcement**:
1. AI significantly accelerates development when used properly
2. Security and compliance require ongoing attention
3. Human expertise remains critical for architectural decisions
4. Proper processes enable safe and effective AI usage

**Individual Action Planning**:
```
"Before you leave, please write down:
1. One AI technique you'll implement this week
2. One security practice you'll establish
3. One thing you'll share with your team
4. One follow-up question or area for deeper learning"
```

**Follow-up Resources**:
- Workshop materials repository
- Recommended learning paths
- Community resources and forums
- Contact information for continued support

---

## Troubleshooting Guide

### Common Technical Issues

#### Issue 1: Copilot Not Working
**Symptoms**: No suggestions, authentication errors
**Quick Fixes**:
1. Check GitHub Copilot subscription status
2. Restart VS Code and re-authenticate
3. Verify internet connectivity
4. Use backup accounts if available

**Prevention**: Have participants test setup before workshop

#### Issue 2: Poor AI Suggestions
**Symptoms**: Irrelevant or incorrect suggestions
**Solutions**:
1. Improve prompt context and specificity
2. Check file type recognition in VS Code
3. Provide better examples and patterns
4. Reset VS Code workspace if needed

#### Issue 3: Performance Issues
**Symptoms**: Slow responses, timeouts
**Solutions**:
1. Check internet bandwidth
2. Close unnecessary VS Code extensions
3. Use backup hotspots
4. Implement turn-taking for bandwidth management

### Engagement Challenges

#### Challenge 1: Mixed Skill Levels
**Strategy**: Pair experienced participants with beginners
**Approach**: Provide advanced challenges for quick finishers

#### Challenge 2: Skeptical Participants
**Strategy**: Acknowledge limitations upfront
**Approach**: Focus on practical benefits and human control

#### Challenge 3: Overreliance on AI
**Strategy**: Emphasize validation and understanding
**Approach**: Ask participants to explain AI-generated code

---

## Assessment and Feedback

### Continuous Assessment
**During Workshop**:
- Observe participant engagement and understanding
- Check in with struggling participants individually
- Adjust pace based on room energy and comprehension
- Capture examples of excellent human-AI collaboration

### Exit Assessment
**Knowledge Check**:
```
Quick Assessment Questions:
1. Name two security considerations when using AI for infrastructure
2. Describe one advanced prompting technique
3. When should human expertise override AI suggestions?
4. What's one policy your organization should implement?
```

**Feedback Collection**:
```
Workshop Feedback Form:
1. Content Quality (1-5 scale)
2. Pace and Structure (1-5 scale)
3. Hands-on Activities (1-5 scale)
4. Facilitator Effectiveness (1-5 scale)
5. Most Valuable Learning
6. Suggested Improvements
7. Likelihood to Recommend (1-10 scale)
```

---

## Post-Workshop Follow-up

### Immediate Actions (Within 24 hours)
- [ ] Send thank you email with workshop materials
- [ ] Share recording (if applicable) and slide deck
- [ ] Provide access to hands-on lab repository
- [ ] Create LinkedIn Learning recommendations

### Short-term Follow-up (Within 1 week)
- [ ] Send curated resource list for continued learning
- [ ] Invite to community forums or follow-up sessions
- [ ] Provide connection to internal experts
- [ ] Share assessment results with participants' managers (if requested)

### Long-term Engagement (1-3 months)
- [ ] Schedule optional follow-up session for questions
- [ ] Share industry updates and new AI developments
- [ ] Collect implementation success stories
- [ ] Gather feedback on real-world application

---

## Success Metrics

### Participant Satisfaction
- **Target**: 4.5/5 average rating
- **Measure**: Post-workshop survey
- **Frequency**: After each workshop

### Knowledge Transfer
- **Target**: 85% pass rate on exit assessment
- **Measure**: Quick knowledge check
- **Frequency**: End of workshop

### Practical Application
- **Target**: 75% implement at least one technique within 30 days
- **Measure**: Follow-up survey
- **Frequency**: 30 days post-workshop

### Organizational Impact
- **Target**: Measurable improvement in development velocity or code quality
- **Measure**: Team productivity metrics
- **Frequency**: 90 days post-workshop

---

## Facilitator Notes and Tips

### Energy Management
- **High-energy openings**: Start each session with energy and purpose
- **Movement and interaction**: Include standing activities and pair work
- **Energy monitoring**: Watch for fatigue and adjust activities accordingly
- **Celebration moments**: Acknowledge successes and breakthroughs

### Technical Facilitation
- **Demo preparation**: Practice all demos multiple times
- **Backup plans**: Have alternative activities ready
- **Real-time adaptation**: Be ready to skip content if technical issues arise
- **Expert positioning**: Position yourself as learning facilitator, not AI expert

### Adult Learning Principles
- **Relevance connection**: Tie all examples to participant contexts
- **Experience building**: Build on participant existing knowledge
- **Problem-solving focus**: Frame learning around solving real problems
- **Reflection integration**: Include time for processing and synthesis

---

**Workshop Success Formula**: Preparation + Flexibility + Participant Focus = Transformative Learning Experience

**Remember**: You're not just teaching AI tools—you're empowering teams to transform their infrastructure development practices while maintaining quality and security standards.
