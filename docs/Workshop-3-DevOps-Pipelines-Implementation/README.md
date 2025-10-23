# Workshop 3 - DevOps Pipelines Implementation

## Overview

A hands-on technical workshop focused on deployment of Infrastructure as Code using GitHub DevOps Pipelines. This workshop is designed for engineers, architects, and operators who need to implement and manage automated infrastructure deployments.

!!! note "Github actions or Azure DevOps?"

    This workshop focuses on GitHub Actions pipelines but similar concepts apply to DevOps pipelines.

    If the documentation only refers to GitHub Actions, you can still try to apply the same exercises using GitHub Actions but the instructor may not be able to provide support.

## Target Audience

- **Software Engineers** building cloud-native applications
- **DevOps Engineers** implementing infrastructure automation
- **Cloud Architects** designing scalable infrastructure
- **Site Reliability Engineers** managing production systems
- **IT Operators** transitioning to cloud infrastructure

## Duration & Format

- **Duration**: 3 hours
- **Format**: Guided Hands-on Lab
- **Environment**: Bring Your Own Device (BYOD) with admin privileges
- **Azure**: Free Azure subscription provided or use existing

## Learning Objectives

By the end of this workshop, participants will:

1. **Implement CI/CD pipelines** using GitHub Actions YAML for infrastructure deployment
1. **Implement complex and multi-environment pipelines** with approval gates and variable groups
1. **Troubleshoot common deployment issues** and understand debugging techniques

## Workshop Agenda

| Time | Session | Activity Type |
|------|---------|---------------|
| **09:00-09:30** | [Prepare a GitHub environment](content/01-github-environment) | Guided Setup |
| **09:30-10:30** | [Simple Single-Stage Pipeline Automation](content/02-pipeline-automation) | Hands-on Lab |
| **10:30-10:45** | 15 min | **Break** | |
| **10:45-11:30** | [Multi-Environment Pipeline Automation](content/03-multienv-pipeline) | Hands-on Lab |
| **11:30-12:00** | [Cleanup](content/04-cleanup) | Cleanup |
| **12:00-12:15** | [Troubleshooting & Q&A](content/05-troubleshooting-qa) | Interactive Discussion |

## Prerequisites

### Technical Skills Required

- Basic command-line interface experience (Windows/Linux/macOS)
- Familiarity with Git concepts (clone, commit, push, pull)
- Understanding of cloud concepts (VMs, networks, storage)
- Good understanding of Infrastructure as Code (IaC) principles (preferably Terraform)
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

---

**Ready to build cloud infrastructure like a pro? Let's get started! 🚀**
