# Demo Resources for Workshop 3

This directory contains demonstration materials, examples, and resources for facilitating Workshop 3: AI for IaC—VS Code Copilot Agent Mode.

## Directory Structure

```
demo/
├── scenarios/                  # Real-world scenarios for hands-on practice
├── examples/                   # Example Terraform configurations
├── vulnerable-configs/         # Intentionally vulnerable configurations for security exercises
├── prompts/                   # Collection of effective prompts and techniques
└── troubleshooting/           # Common issues and solutions
```

## Usage Instructions

### For Facilitators
1. Review all demo materials before the workshop
2. Test each example in your environment
3. Customize scenarios to match participant backgrounds
4. Prepare backup versions for technical issues

### For Participants
These resources support your hands-on learning during the workshop:
- **scenarios/**: Practice building infrastructure for realistic use cases
- **examples/**: Reference implementations for common patterns
- **prompts/**: Proven prompts and techniques for effective AI interaction
- **vulnerable-configs/**: Security exercises and remediation practice

## Quick Start Guide

### Demo Environment Setup
1. Ensure GitHub Copilot is installed and authenticated
2. Clone this workshop repository
3. Open VS Code in the workshop directory
4. Verify Copilot functionality with basic test

### Testing Your Setup
```terraform
// Create new file: setup-test.tf
// Type the comment below and wait for Copilot suggestions

// Create an Azure resource group in East US for testing
```

If Copilot provides resource suggestions, you're ready to begin!

## Support
- **During Workshop**: Raise your hand or ask your facilitator
- **After Workshop**: Reference the troubleshooting guide or community forums
- **Advanced Questions**: Schedule follow-up consultation sessions

---

**Next**: Explore the specific scenario and example directories for detailed practice materials.
