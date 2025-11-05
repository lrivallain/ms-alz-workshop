#!/bin/bash
# .devcontainer/post-create.sh

set -e

echo "🚀 Setting up ALZ Workshop Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Update package lists
print_status "Updating package lists..."
sudo apt-get update

# Install additional packages
print_status "Installing additional development tools..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    jq \
    tree \
    vim \
    nano \
    htop \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

# Create Terraform plugin cache directory
print_status "Creating Terraform plugin cache directory..."
mkdir -p /tmp/terraform-plugin-cache
sudo chown -R vscode:vscode /tmp/terraform-plugin-cache

# Ensure /workspaces ownership
print_status "Setting ownership for /workspaces..."
sudo chown -R vscode:vscode /workspaces 2>/dev/null || true

# Configure Terraform CLI config
print_status "Configuring Terraform CLI..."
cat > /workspaces/.terraformrc << 'EOF'
plugin_cache_dir = "/tmp/terraform-plugin-cache"
disable_checkpoint = true
disable_checkpoint_signature = true
EOF

# Set up Git configuration template
print_status "Setting up Git configuration template..."
cat > /home/vscode/.gitconfig-template << 'EOF'
[user]
    name = Your Name
    email = your.email@company.com
[core]
    autocrlf = input
    editor = code --wait
[init]
    defaultBranch = main
[credential]
    helper = store
[pull]
    rebase = false
[push]
    default = simple
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
    tree = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
EOF

# Create workspace directories
print_status "Creating workspace directory structure..."
mkdir -p /workspaces/terraform-workshop/terraform

# Verify installations
print_status "Verifying tool installations..."

echo "Checking tool versions:"
echo "  Git: $(git --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "  Azure CLI: $(az --version 2>/dev/null | head -1 || echo 'NOT INSTALLED')"
echo "  Terraform: $(terraform version 2>/dev/null | head -1 || echo 'NOT INSTALLED')"

# Create helpful aliases
print_status "Setting up helpful aliases..."
cat >> /home/vscode/.bashrc << 'EOF'
# Workshop specific
alias workshop='cd /workspaces/terraform-workshop'
alias lab='cd /workspaces/terraform-workshop/terraform'

echo "🎓 ALZ Workshop Environment Ready!"
echo "💡 Tips:"
echo "   - Run 'workshop' to go to workshop directory"
echo "   - Run 'lab' to go to terraform directory"
echo "   - Configure git with: git config --global user.name 'Your Name'"
echo "   - Configure git with: git config --global user.email 'your@email.com'"
EOF

# Set ownership for home and workspaces if not already set
sudo chown -R vscode:vscode /home/vscode
sudo chown -R vscode:vscode /workspaces 2>/dev/null || true

print_success "🎉 ALZ Workshop Development Environment setup complete!"
print_status "🔧 Next steps:"
echo "   1. Configure Git with your name and email"
echo "   2. Login to Azure CLI: az login"
echo "   3. Set your default subscription: az account set --subscription 'Your Subscription'"
echo "   4. Start with the workshop materials!"

# Display welcome message
cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════════╗
║                   🚀 ALZ Workshop Environment Ready! 🚀                      ║
║                                                                              ║
║  This devcontainer includes:                                                 ║
║  ✅ Git, Azure CLI, Terraform, Node.js                                       ║
║  ✅ VS Code extensions for Terraform, Azure, and DevOps                      ║
║  ✅ Pre-configured settings and aliases                                      ║
║  ✅ Workshop directory: /workspaces/terraform-workshop                       ║
║                                                                              ║
║  Quick start:                                                                ║
║  • Run 'workshop' to navigate to workshop directory                          ║
║  • Configure Git: git config --global user.name "Your Name"                  ║
║  • Login to Azure: az login                                                  ║
║  • Set your sub: az account set --subscription 'Your Subscription'.          ║
║                                                                              ║
║  YOUR WORKING DIRECTORY IS: /workspaces/terraform-workshop.                  ║
║  (do not confuse with /workspaces/ms-alz-workshop directory)                 ║
║                                                                              ║
║  Happy learning! 📚                                                          ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF