#!/bin/bash

# macOS Setup Script for MacBook Air M4
# Installs Homebrew and selected applications

# Check if script is being run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script should not be run as root. Please run as a normal user."
    exit 1
fi

# Check if we're on Apple Silicon
if [ "$(uname -m)" != "arm64" ]; then
    echo "This script is optimized for Apple Silicon (M1/M2/M3/M4) Macs."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [ "$(uname -m)" = "arm64" ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed. Updating..."
    brew update
fi

# Install applications
echo "Installing applications..."

# Install Google Chrome
brew install --cask google-chrome

# Install iTerm2
brew install --cask iterm2

# Install Steam
brew install --cask steam

# Install JetBrains Toolbox (corrected from intellij-idea-ce)
brew install --cask jetbrains-toolbox

# Install Visual Studio Code
brew install --cask visual-studio-code

# Install some useful CLI tools
echo "Installing useful CLI tools..."
brew install wget git tree

# Cleanup
brew cleanup

echo "Installation complete!"
echo "The following applications were installed:"
echo "- Google Chrome"
echo "- iTerm2"
echo "- Steam"
echo "- JetBrains Toolbox (to manage all JetBrains IDEs)"
echo "- Visual Studio Code"
echo ""
echo "Additional CLI tools installed: wget, git, tree"
