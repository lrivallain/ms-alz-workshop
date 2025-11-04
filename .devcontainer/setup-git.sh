#!/bin/bash
# Helper script for Git configuration

echo "🔧 Git Configuration Setup"
echo "Please enter your Git configuration details:"

read -p "Enter your full name: " git_name
read -p "Enter your email address: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global core.autocrlf input
git config --global init.defaultBranch main
git config --global credential.helper store

echo "✅ Git configured successfully!"
echo "Name: $git_name"
echo "Email: $git_email"