# Lab 1: Copilot Setup and Validation

## Lab Overview
**Duration**: 30 minutes  
**Objective**: Set up and validate GitHub Copilot environment for Terraform development  
**Prerequisites**: VS Code installed, GitHub account with Copilot subscription

---

## Lab Objectives

By the end of this lab, you will:
- Have a fully configured GitHub Copilot environment in VS Code
- Understand different Copilot interaction modes
- Validate Copilot functionality with Terraform
- Configure optimal settings for infrastructure development
- Complete basic interaction exercises with AI assistance

---

## Part 1: Environment Setup and Installation

### Step 1: Verify Prerequisites

**Check GitHub Copilot Subscription**:
1. Go to [GitHub.com](https://github.com)
2. Navigate to Settings → Billing
3. Verify active Copilot subscription (Individual or Business)
4. Note your subscription type and features

**VS Code Version Check**:
```bash
# Check VS Code version (should be recent)
code --version

# Expected output: Version 1.80+ recommended
```

### Step 2: Install Required Extensions

**Install GitHub Copilot Extensions**:
1. Open VS Code
2. Go to Extensions (`Ctrl+Shift+X` or `Cmd+Shift+X`)
3. Search and install the following extensions:

**Required Extensions**:
- `GitHub.copilot` - GitHub Copilot
- `GitHub.copilot-chat` - GitHub Copilot Chat
- `HashiCorp.terraform` - Terraform language support
- `ms-vscode.azure-account` - Azure Account integration

**Recommended Extensions**:
- `ms-vscode.vscode-json` - JSON language features
- `redhat.vscode-yaml` - YAML language support
- `eamodio.gitlens` - Git supercharged

**Installation Verification**:
```bash
# List installed extensions (PowerShell)
code --list-extensions | Select-String "copilot|terraform|azure"

# List installed extensions (Bash/Zsh)
code --list-extensions | grep -E "(copilot|terraform|azure)"

# Expected output should include:
# GitHub.copilot
# GitHub.copilot-chat
# HashiCorp.terraform
# ms-vscode.azure-account
```

### Step 3: Authentication and Configuration

**Authenticate with GitHub**:
1. Open Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type: `GitHub Copilot: Sign In`
3. Follow authentication prompts
4. Grant necessary permissions

**Verify Authentication**:
1. Check status bar for Copilot icon
2. Icon should show "Ready" or checkmark
3. If issues, check notification panel for messages

**Configure Copilot Settings**:
```json
// Open Settings (JSON): Ctrl+Shift+P → "Preferences: Open Settings (JSON)"
// Add or verify these settings:
{
    "github.copilot.enable": {
        "*": true,
        "terraform": true,
        "yaml": true,
        "json": true,
        "markdown": true
    },
    "github.copilot.inlineSuggest.enable": true,
    "github.copilot.chat.followUps": "always",
    "terraform.languageServer": {
        "external": true,
        "args": ["serve"]
    }
}
```

---

## Part 2: Basic Functionality Validation

### Step 1: Create Test Workspace

**Set up Test Environment**:
```bash
# Create workshop directory
mkdir copilot-terraform-workshop
cd copilot-terraform-workshop

# Initialize as Git repository
git init

# Open in VS Code
code .
```

### Step 2: Test Basic Code Completion

**Create test file** `test-basic.tf`:
```terraform
# Test basic Copilot functionality
# Type each line slowly and observe suggestions

# Test 1: Basic resource completion
# Type: resource "azurerm_
# Expected: Copilot suggests various Azure resources

resource "azurerm_resource_group" "test" {
  # Test 2: Parameter completion
  # Type: name = "
  # Expected: Copilot suggests name patterns
  
  # Type: location = 
  # Expected: Copilot suggests Azure regions
}

# Test 3: Pattern recognition
# Create a second similar resource and observe pattern completion
```

**Validation Checklist**:
- [ ] Copilot provides resource type suggestions
- [ ] Parameter completion works correctly
- [ ] Suggestions appear within 2-3 seconds
- [ ] Multiple suggestions available with `Alt+]` and `Alt+[`
- [ ] Suggestions can be accepted with `Tab`

### Step 3: Test Copilot Chat

**Open Copilot Chat**:
1. Click Copilot icon in Activity Bar (left sidebar)
2. Or use `Ctrl+I` (Windows/Linux) or `Cmd+I` (Mac) to open inline chat
3. Or open Command Palette → "GitHub Copilot: Open Chat"

**Chat Functionality Tests**:

```
Test Query 1: "What is Terraform and how does it work?"
Expected: Detailed explanation of Infrastructure as Code

Test Query 2: "Explain this Terraform resource and suggest improvements"
[Select the resource group from test-basic.tf]
Expected: Explanation and improvement suggestions

Test Query 3: "Generate a complete web application infrastructure for Azure"
Expected: Multi-resource Terraform configuration
```

### Step 4: Test Context Awareness

**Create context test** `context-test.tf`:
```terraform
# Context Awareness Test
# Define variables first to establish context

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "webapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Now test if Copilot uses these variables in suggestions
# Type the following and observe if Copilot references the variables:

resource "azurerm_resource_group" "main" {
  # Type: name = "${var.
  # Expected: Copilot suggests using the defined variables
  
  # Type: tags = {
  # Expected: Copilot suggests relevant tags including environment
```

---

## Part 3: Terraform-Specific Configuration

### Step 1: Configure Terraform Language Server

**Create Terraform configuration** `.terraform-version`:
```
1.5.7
```

**Create VS Code workspace settings** `.vscode/settings.json`:
```json
{
    "terraform.validate": {
        "enable": true
    },
    "terraform.codelens.referenceCount": true,
    "terraform.format": {
        "enable": true
    },
    "files.associations": {
        "*.tf": "terraform",
        "*.tfvars": "terraform-vars"
    },
    "editor.formatOnSave": true,
    "[terraform]": {
        "editor.defaultFormatter": "hashicorp.terraform",
        "editor.formatOnSave": true
    },
    "[terraform-vars]": {
        "editor.defaultFormatter": "hashicorp.terraform",
        "editor.formatOnSave": true
    }
}
```

### Step 2: Test Terraform Integration

**Create comprehensive test** `terraform-integration-test.tf`:
```terraform
# Terraform Integration Test
# This file tests Copilot's understanding of Terraform concepts

terraform {
  required_version = ">=1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Test 1: Provider configuration
# Type this comment and let Copilot generate the provider block:
# Configure Azure provider with features block for resource management

# Test 2: Data source completion
# Type: data "azurerm_
# Expected: Copilot suggests various Azure data sources

# Test 3: Local values
# Type: locals {
# Expected: Copilot suggests common local value patterns

# Test 4: Output generation
# Type: output "
# Expected: Copilot suggests outputs based on resources in file
```

### Step 3: Test Advanced Features

**Create advanced test** `advanced-features-test.tf`:
```terraform
# Advanced Features Test

# Test dynamic blocks
# Comment: Create network security group with dynamic security rules
# Expected: Copilot generates dynamic block structure

# Test for_each patterns  
# Comment: Create multiple storage accounts for different environments
# Expected: Copilot suggests for_each implementation

# Test conditional resources
# Comment: Create Application Gateway only in production environment
# Expected: Copilot suggests count or for_each with conditions

# Test complex expressions
# Comment: Generate complex local values for resource naming
# Expected: Copilot creates sophisticated naming patterns
```

---

## Part 4: Performance and Quality Validation

### Step 1: Response Time Testing

**Instructions**:

1.  Open the `terraform-integration-test.tf` file.
2.  Position your cursor after one of the test comments (e.g., after line 260: `# Configure Azure provider...`).
3.  Manually time how long it takes for the first Copilot suggestion to appear.
4.  Record your observations.

**Expected benchmarks**:
- Simple completions: <1 second
- Complex generations: 2-5 seconds
- Chat responses: 3-10 seconds

### Step 2: Suggestion Quality Assessment

**Create quality assessment** `quality-checklist.md`:
```markdown
# Copilot Suggestion Quality Checklist

## Code Completions
- [ ] Suggestions are syntactically correct
- [ ] Follow Terraform best practices
- [ ] Use appropriate Azure resource types
- [ ] Include required arguments
- [ ] Follow consistent naming patterns

## Chat Responses
- [ ] Provide accurate information
- [ ] Include relevant examples
- [ ] Address the specific question
- [ ] Suggest best practices
- [ ] Include security considerations

## Context Understanding
- [ ] References existing variables
- [ ] Maintains consistent patterns
- [ ] Understands project structure
- [ ] Considers file relationships
- [ ] Follows established conventions
```

### Step 3: Troubleshooting Verification

**Test common issues**:

1. **No suggestions appearing**:
   ```bash
   # Verify Copilot status
   # Check: Status bar shows Copilot icon
   # Check: Extensions are enabled
   # Check: File type is recognized as Terraform
   ```

2. **Poor quality suggestions**:
   ```terraform
   # Test context improvement
   # Add more descriptive comments
   # Use consistent naming patterns
   # Include more context in variable names
   ```

3. **Slow performance**:
   ```bash
   # Check internet connection
   # Verify VS Code performance
   # Check for conflicting extensions
   # Restart VS Code if needed
   ```

---

## Part 5: Integration Validation

### Step 1: Git Integration Test

**Create Git workflow test**:
```bash
# Test Git integration with Copilot
git add .
git commit -m "Initial Copilot setup validation"

# Test: Does Copilot understand Git history?
# Create new file and see if Copilot references previous commits
```

### Step 2: Multi-File Context Test

**Create module structure**:
```bash
# Create module directory structure
mkdir -p modules/networking
mkdir -p modules/compute
mkdir -p environments/dev
mkdir -p environments/prod

# Create files to test cross-file context
touch modules/networking/main.tf
touch modules/networking/variables.tf
touch modules/networking/outputs.tf
```

**Test cross-file awareness**:
```terraform
# In modules/networking/variables.tf
variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# In modules/networking/main.tf
# Test: Does Copilot reference variables from variables.tf?
# Type: resource "azurerm_virtual_network" "main" {
# Expected: Copilot suggests using var.vnet_address_space
```

---

## Lab Validation and Completion

### Validation Checklist

**Environment Setup**:
- [ ] GitHub Copilot extensions installed and active
- [ ] Authentication successful (status bar shows ready)
- [ ] Terraform language server working
- [ ] VS Code settings optimized for Copilot

**Basic Functionality**:
- [ ] Code completions work reliably
- [ ] Copilot Chat responds accurately
- [ ] Multiple suggestions available
- [ ] Suggestions can be accepted/dismissed

**Terraform Integration**:
- [ ] Terraform-specific suggestions appear
- [ ] Context awareness across files
- [ ] Pattern recognition working
- [ ] Best practices included in suggestions

**Performance**:
- [ ] Response times acceptable (<5 seconds)
- [ ] No errors or crashes
- [ ] Stable performance across sessions
- [ ] Resource usage reasonable

### Common Issues and Solutions

#### Issue 1: Copilot Not Suggesting
**Symptoms**: No suggestions appear when typing
**Solutions**:
1. Check Copilot status in status bar
2. Verify file type is recognized (check language mode)
3. Try `Ctrl+Shift+P` → "GitHub Copilot: Open Completions Panel"
4. Restart VS Code
5. Re-authenticate with GitHub

#### Issue 2: Poor Quality Suggestions
**Symptoms**: Irrelevant or incorrect suggestions
**Solutions**:
1. Add more context in comments
2. Use descriptive variable names
3. Ensure file structure is clear
4. Check if Terraform language server is running
5. Provide more detailed prompts

#### Issue 3: Chat Not Responding
**Symptoms**: Copilot Chat panel empty or errors
**Solutions**:
1. Check internet connection
2. Verify GitHub authentication
3. Try opening in new chat session
4. Clear VS Code cache
5. Update Copilot extensions

### Next Steps

**Prepare for Next Lab**:
1. Keep VS Code open with Copilot active
2. Familiarize yourself with keyboard shortcuts:
   - `Tab` - Accept suggestion
   - `Alt+]` - Next suggestion
   - `Alt+[` - Previous suggestion  
   - `Ctrl+Alt+I` - Inline chat
   - `Esc` - Dismiss suggestion

**Practice Exercises** (Optional):
1. Try generating different Azure resource types
2. Practice using Copilot Chat for explanations
3. Test pattern recognition with similar resources
4. Experiment with different prompt styles

---

## Lab Completion

### Success Criteria

You have successfully completed Lab 1 if:

1. ✅ **Copilot is active** and showing suggestions in VS Code
2. ✅ **Chat functionality** is working and responding accurately
3. ✅ **Terraform integration** is functioning with proper syntax highlighting
4. ✅ **Performance is acceptable** with reasonable response times
5. ✅ **Basic troubleshooting** knowledge acquired for common issues

### Knowledge Gained

- GitHub Copilot setup and configuration
- Basic interaction patterns with AI assistance
- Terraform-specific AI development environment
- Quality assessment criteria for AI suggestions
- Troubleshooting common issues

**Ready for Lab 2**: [AI-Assisted Infrastructure Development](02-ai-assisted-infrastructure.md)

---

**Congratulations!** Your AI-assisted Terraform development environment is ready. You can now leverage GitHub Copilot to accelerate your infrastructure development while maintaining quality and security standards.
