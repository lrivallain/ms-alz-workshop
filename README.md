# DevOps & IaC Workshop

The workshops provide hands-on exercises to guide you through the practical implementation of Infrastructure-as-Code concepts applied in Azure Landing Zones scenarios.

## Workshops

This repository is organized into workshops lasting a few hours each:

1. **[Workshop 1: Modern DevOps & IaC Essentials](Workshop-1-Modern-DevOps-IaC-Essentials/README.md)**
    - Introduction to Infrastructure as Code (IaC), source control with Git, and modern development workflows.

2. **[Workshop 2: Practical IaC with Terraform & Azure Modules](Workshop-2-Practical-IaC-Terraform-Azure-Modules/README.md)**
    - Deep dive into using Terraform for Azure, leveraging Terraform modules for reusability, and managing state.

3. **[Workshop 3: DevOps Pipelines Implementation](./Workshop-3-DevOps-Pipelines-Implementation)**
    - Implementing CI/CD pipelines for automated testing and deployment of infrastructure code.

## Getting Started

To get started, clone this repository and navigate to the desired workshop folder. Each workshop contains its own set of instructions and materials.

```bash
git clone https://github.com/lrivallain/ms-alz-workshop.git
cd ms-alz-workshop/Workshop-1-Modern-DevOps-IaC-Essentials
```

### Run this locally

If you want to run the documentation site locally, you have two options:

#### With Docker

You can use a Docker compose to run a local instance of the documentation site. Make sure you have Docker installed on your machine.

```bash
docker-compose up
```

Then open your browser and navigate to `http://localhost:8000`.

#### Without Docker

Install `uv` and dependencies:

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Dependencies
uv sync
```

Run the documentation site:

```bash
chmod +x ./run.sh
./run.sh
```

Then open your browser and navigate to `http://localhost:8000`.