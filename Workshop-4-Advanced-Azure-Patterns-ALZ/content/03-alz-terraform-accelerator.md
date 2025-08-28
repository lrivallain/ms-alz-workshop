# Module 3: ALZ Terraform Accelerator

## Learning Objectives
After completing this module, you will be able to:
- Deploy Azure Landing Zones using the ALZ Terraform Accelerator PowerShell module.
- Understand the accelerator's automated bootstrap process.
- Differentiate between a local deployment and a CI/CD-integrated deployment.

## Prerequisites
- Completion of Module 1 (ALZ Fundamentals)
- PowerShell 7.0 or later
- Azure CLI installed and authenticated
- An Azure subscription with Owner permissions.

## What is the ALZ Terraform Accelerator?

The **ALZ Terraform Accelerator** is Microsoft's current recommended tool for rapidly deploying a production-ready Azure Landing Zone foundation. It is a PowerShell module that automates the entire setup process.

Key features:
-   **🚀 Automated Bootstrap**: A single PowerShell command (`Deploy-Accelerator`) drives the entire setup.
-   **📝 File-Based or Interactive**: Can be run non-interactively using configuration files (ideal for automation and labs) or interactively for guided setup.
-   **🏗️ AVM-Based**: The process **generates** Terraform code that is built on official Azure Verified Modules (AVM).
-   **🔄 CI/CD Ready**: Can be used for a one-off local deployment or to bootstrap a complete GitHub Actions CI/CD workflow.

### Step 1: Install the ALZ PowerShell Module

First, ensure you have the required PowerShell module installed from the PowerShell Gallery.

```powershell
# Check if the module is installed
Get-InstalledModule -Name ALZ

# Install or update as needed
# Install-Module -Name ALZ -Scope CurrentUser
# Update-Module -Name ALZ
```

### Step 2: Configure the Deployment (File-Based Method)

For a repeatable and automated deployment, the accelerator uses configuration files. This is the method used in the hands-on lab.

1.  **Create a Directory Structure**:
    ```powershell
    New-Item -ItemType Directory -Path '.\accelerator\config', '.\accelerator\output' -Force
    ```

2.  **Create `inputs.yaml`**: This file contains the core settings. You define the type of deployment (`alz_local`), subscription IDs, location, and resource naming.
    ```yaml
    # Example inputs.yaml for a local deployment
    iac_type: terraform
    bootstrap_module_name: alz_local # Key for a local deployment
    starter_module_name: platform_landing_zone
    bootstrap_location: eastus
    # ... other parameters ...
    ```

3.  **Create `platform-landing-zone.tfvars`**: This file is passed to the ALZ AVM module to configure the platform, such as networking topology. An empty file can be used to deploy the defaults.

### Step 3: Run the Bootstrap

The core of the accelerator is the `Deploy-Accelerator` command.

```powershell
# Run the accelerator with the configuration files
Deploy-Accelerator `
-inputs ".\accelerator\config\inputs.yaml", ".\accelerator\config\platform-landing-zone.tfvars" `
-output ".\accelerator\output"
```

The command will:
1.  Read the configuration from your files.
2.  Generate a complete Terraform project in the `output` directory.
3.  Run `terraform init` and `terraform plan`.
4.  Pause for your approval before running `terraform apply`.

### Deployment Methods: Local vs. CI/CD

The accelerator supports two primary modes, controlled by the `bootstrap_module_name` in your `inputs.yaml`:

-   `alz_local`: This generates a standalone Terraform project on your local machine. You manage the state and apply changes from your machine. This is excellent for learning and proof-of-concept deployments.
-   `alz_github` / `alz_azdo`: These modes bootstrap a full CI/CD pipeline in GitHub Actions or Azure DevOps. The accelerator creates the repository, pipelines, and service connections, providing a production-ready workflow.

## Advantages of the ALZ Accelerator

The accelerator is the recommended approach for most organizations because it provides the fastest and most reliable path to a production-ready, AVM-based ALZ platform, complete with best-practice configurations for either local management or full CI/CD.

## What Has Been Deployed? The ALZ Foundation

After running the accelerator, you have a complete, production-grade foundation for your Azure environment. This is more than just a set of resources; it's a governed and structured platform. The key components are:

#### 1. A Best-Practice Management Group Hierarchy

The accelerator creates a new management group structure to properly segment and govern your Azure subscriptions. This includes:

-   **`alzroot`**: The top-level management group for your entire landing zone.
-   **`platform`**: Contains subscriptions for central platform services.
    -   `identity`: For identity services like domain controllers.
    -   `management`: For central monitoring and management.
    -   `connectivity`: For hub networking resources.
-   **`landingzones`**: The parent for all your application subscriptions.
-   **`sandboxes`**: For development/testing with more relaxed policies.
-   **`decommissioned`**: For retiring subscriptions.

#### 2. A Comprehensive Policy Framework

Hundreds of Azure Policies are assigned across the hierarchy to enforce security and governance. This framework ensures that any new subscription or resource placed within the hierarchy automatically inherits the appropriate guardrails.

#### 3. Generated Terraform Code

In the `accelerator/output/local-output` directory, you have the complete Terraform project that defines this foundation. This code is your starting point for managing and evolving your platform.

### Next Steps: Building on the Foundation

With the foundation in place, the next logical steps, which will be covered in the following modules and labs, are:

1.  **Deploy Connectivity**: Use the generated Terraform code to configure and deploy the central **hub network**.
2.  **Vend a Landing Zone**: Use the `lz-vending` module to deploy a **spoke network** for an application into an existing subscription.
3.  **Establish Peering and Routing**: Connect the spoke to the hub, configure DNS, and route traffic through the central firewall, completing the Hub-and-Spoke topology.

---

**Next Module**: [Module 4: Subscription Vending](04-subscription-vending.md)
