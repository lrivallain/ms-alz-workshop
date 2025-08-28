# Source Control & Git Workflows

## Introduction to Source Control

Source control (also known as version control) is a system that tracks changes to files over time, allowing multiple developers to collaborate on the same codebase while maintaining a complete history of modifications.

```mermaid
graph TB
    A[Working Directory] --> B[Staging Area]
    B --> C[Local Repository]
    C --> D[Remote Repository]
    
    subgraph "Git Workflow"
        E[git add] --> B
        F[git commit] --> C
        G[git push] --> D
        H[git pull] --> A
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
```

## Why Source Control for Infrastructure?

### Infrastructure as Code Needs Version Control
Just like application code, infrastructure code requires:
- **Change tracking**: Who changed what, when, and why
- **Collaboration**: Multiple team members working on infrastructure
- **Rollback capability**: Ability to revert problematic changes
- **Branching**: Parallel development of features
- **Audit trail**: Compliance and governance requirements

```mermaid
timeline
    title Infrastructure Change History
    
    2024-01-15 : Initial Infrastructure
               : Basic Web App + Database
    
    2024-01-20 : Add Load Balancer
               : Scale for increased traffic
    
    2024-02-01 : Security Updates
               : WAF + Network Security Groups
    
    2024-02-15 : Database Migration
               : Move to Premium SKU
    
    2024-03-01 : Multi-Region Setup
               : Add disaster recovery
```

## Git Fundamentals for Infrastructure Teams

### Core Git Concepts

```mermaid
graph LR
    subgraph "Repository Structure"
        A[Working Directory] --> B[Index/Staging]
        B --> C[Local Repo]
        C --> D[Remote Repo]
    end
    
    subgraph "File States"
        E[Modified]
        F[Staged]
        G[Committed]
        H[Pushed]
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
```

### Essential Git Commands for IaC

| Command | Purpose | Example |
|---------|---------|---------|
| `git init` | Initialize repository | `git init terraform-project` |
| `git add` | Stage changes | `git add main.tf` |
| `git commit` | Save changes | `git commit -m "Add web app resource"` |
| `git push` | Upload to remote | `git push origin main` |
| `git pull` | Download from remote | `git pull origin main` |
| `git branch` | Create/list branches | `git branch feature/add-database` |
| `git merge` | Combine branches | `git merge feature/add-database` |

## Branching Strategies for Infrastructure

### GitFlow for Infrastructure Teams

```mermaid
gitGraph
    commit id: "Initial"
    branch develop
    commit id: "Setup base infra"
    branch feature/web-app
    commit id: "Add web app"
    commit id: "Configure scaling"
    checkout develop
    merge feature/web-app
    branch feature/database
    commit id: "Add SQL database"
    commit id: "Configure backups"
    checkout develop
    merge feature/database
    checkout main
    merge develop id: "Release v1.0"
    branch hotfix/security
    commit id: "Security patch"
    checkout main
    merge hotfix/security
    checkout develop
    merge hotfix/security
```

### Environment-Based Branching

```mermaid
graph TB
    A[main/production] --> B[staging]
    B --> C[development]
    
    D[feature/new-service] --> C
    E[feature/database-upgrade] --> C
    F[hotfix/security-patch] --> B
    F --> A
    
    subgraph "Deployment Targets"
        G[Production Azure Subscription]
        H[Staging Azure Subscription]
        I[Development Azure Subscription]
    end
    
    A --> G
    B --> H
    C --> I
```

## Pull Request (PR) Workflow

### The PR Process for Infrastructure Changes

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant BR as Feature Branch
    participant PR as Pull Request
    participant Rev as Reviewers
    participant Main as Main Branch
    participant CI as CI/CD Pipeline
    participant Azure as Azure Environment
    
    Dev->>BR: Create feature branch
    Dev->>BR: Make infrastructure changes
    Dev->>BR: Commit changes
    Dev->>PR: Create Pull Request
    PR->>Rev: Request reviews
    Rev->>PR: Code review & approval
    PR->>CI: Trigger automated tests
    CI->>CI: Plan & validate changes
    CI->>PR: Report test results
    PR->>Main: Merge to main branch
    Main->>CI: Trigger deployment
    CI->>Azure: Deploy infrastructure
```

### PR Review Checklist for Infrastructure

#### Security & Compliance
- [ ] No hardcoded secrets or sensitive data
- [ ] Proper access controls and permissions
- [ ] Network security groups configured appropriately
- [ ] Encryption enabled where required

#### Best Practices
- [ ] Resources follow naming conventions
- [ ] Tags applied consistently
- [ ] Resource groups organized logically
- [ ] Cost optimization considerations

#### Technical Quality
- [ ] Code follows DRY principles
- [ ] Variables and outputs properly defined
- [ ] Documentation updated
- [ ] Terraform plan output reviewed

```mermaid
graph TB
    subgraph "PR Review Gates"
        A[Automated Checks]
        B[Security Scan]
        C[Cost Analysis]
        D[Peer Review]
        E[Architecture Review]
    end
    
    F[Pull Request] --> A
    A --> B
    B --> C
    C --> D
    D --> E
    E --> G[Merge Approval]
    
    subgraph "Review Outcomes"
        H[Approve]
        I[Request Changes]
        J[Comment]
    end
    
    G --> H
    G --> I
    G --> J
```

## Azure DevOps Integration

### Azure Repos with Infrastructure Code

```mermaid
graph TB
    subgraph "Azure DevOps"
        A[Azure Repos]
        B[Azure Pipelines]
        C[Azure Boards]
        D[Azure Artifacts]
    end
    
    subgraph "Infrastructure Repository"
        E[Terraform Files]
        F[Pipeline YAML]
        G[Documentation]
        H[Test Scripts]
    end
    
    A --> E
    A --> F
    A --> G
    A --> H
    
    B --> I[Build & Test]
    B --> J[Plan & Apply]
    
    subgraph "Deployment Process"
        K[terraform plan]
        L[Manual Approval]
        M[terraform apply]
        N[Post-deployment Tests]
    end
    
    I --> K
    K --> L
    L --> M
    M --> N
```

### Branch Policies for Infrastructure

```mermaid
graph TB
    subgraph "Branch Protection Rules"
        A[Require PR for main branch]
        B[Require reviewer approval]
        C[Require build validation]
        D[Require up-to-date branches]
        E[Require comment resolution]
    end
    
    subgraph "Automated Checks"
        F[Terraform fmt]
        G[Terraform validate]
        H[Security scanning]
        I[Cost estimation]
    end
    
    C --> F
    C --> G
    C --> H
    C --> I
    
    subgraph "Quality Gates"
        J[All checks pass]
        K[Approvals received]
        L[Ready to merge]
    end
    
    A --> J
    B --> K
    J --> L
    K --> L
```

## Git Best Practices for Infrastructure

### Repository Structure
```
terraform-azure-infrastructure/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── web-app/
│   ├── database/
│   └── networking/
├── policies/
├── scripts/
├── .gitignore
├── README.md
└── CONTRIBUTING.md
```

### Commit Message Guidelines

```mermaid
graph TB
    A[Good Commit Message] --> B[Type: Description]
    B --> C["feat: add Azure SQL database configuration"]
    B --> D["fix: resolve storage account access issue"]
    B --> E["docs: update deployment instructions"]
    B --> F["refactor: modularize network configuration"]
    
    subgraph "Message Structure"
        G[Type] --> H[Description]
        H --> I[Body - Optional]
        I --> J[Footer - Optional]
    end
    
    subgraph "Common Types"
        K[feat - New feature]
        L[fix - Bug fix]
        M[docs - Documentation]
        N[refactor - Code restructure]
        O[test - Add tests]
    end
```

## GitHub vs Azure DevOps Comparison

| Feature | GitHub | Azure DevOps |
|---------|---------|---------------|
| **Repository Hosting** | Excellent | Excellent |
| **Pull Requests** | GitHub PR | Azure DevOps PR |
| **CI/CD Integration** | GitHub Actions | Azure Pipelines |
| **Project Management** | GitHub Issues/Projects | Azure Boards |
| **Package Management** | GitHub Packages | Azure Artifacts |
| **Enterprise Integration** | GitHub Enterprise | Native Azure integration |
| **Cost** | Free for public repos | Free tier available |

## Exercise: Git Workflow Simulation

### Scenario Setup (15 minutes)
You're working on adding a new Azure SQL Database to your infrastructure:

1. **Create a feature branch**
   ```bash
   git checkout -b feature/add-sql-database
   ```

2. **Make changes to infrastructure code**
   - Add database configuration
   - Update variables
   - Modify outputs

3. **Stage and commit changes**
   ```bash
   git add .
   git commit -m "feat: add Azure SQL database with backup configuration"
   ```

4. **Push branch and create PR**
   ```bash
   git push origin feature/add-sql-database
   ```

### PR Review Simulation

#### Review Checklist Activity
Work in pairs to review this sample Terraform code:

```terraform
resource "azurerm_sql_server" "example" {
  name                = "sqlserver${random_id.server.hex}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  version             = "12.0"
  administrator_login = "admin123"
  administrator_login_password = "P@ssw0rd123!"
}
```

**Questions to Consider:**
- What security issues do you see?
- How could this be improved?
- What's missing for production readiness?

## Common Git Mistakes and Solutions

```mermaid
graph TB
    subgraph "Common Mistakes"
        A[Committing secrets]
        B[Large binary files]
        C[Direct commits to main]
        D[Unclear commit messages]
        E[Not syncing branches]
    end
    
    subgraph "Solutions"
        F[Use .gitignore + secrets management]
        G[Git LFS or external storage]
        H[Branch protection rules]
        I[Commit message conventions]
        J[Regular git pull/fetch]
    end
    
    A --> F
    B --> G
    C --> H
    D --> I
    E --> J
```

## Discussion Questions

1. **For Managers**: How can proper Git workflows improve compliance and audit capabilities?

2. **For Technical Teams**: What challenges have you faced with infrastructure change management?

3. **For Everyone**: How do you balance speed of delivery with proper review processes?

## Key Takeaways

✅ **Version control is essential for infrastructure code**  
✅ **Branching strategies enable parallel development**  
✅ **Pull requests provide quality gates**  
✅ **Automated checks reduce manual review burden**  
✅ **Proper commit messages create valuable history**  
✅ **Branch protection prevents direct production changes**

## Security Considerations

🔒 **Never commit secrets to version control**  
🔒 **Use branch protection rules**  
🔒 **Implement automated security scanning**  
🔒 **Require code reviews for sensitive changes**  
🔒 **Audit access to infrastructure repositories**

## Next Steps
- Set up repository with proper structure
- Configure branch protection rules
- Create PR templates for infrastructure changes
- Implement automated validation checks
- Train team on Git best practices

---

*Continue to: [What is Terraform?](./04-terraform-basics.md)*
