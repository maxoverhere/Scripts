#!/bin/bash

# Install Oh My Zsh (if not already installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme (better than default)
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
else
    echo "Powerlevel10k theme already installed."
fi

# Install Zsh plugins (syntax highlighting + autosuggestions)
echo "Installing Zsh plugins..."
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

# Configure ~/.zshrc
echo "Updating ~/.zshrc..."
cat > ~/.zshrc << 'EOL'
# Oh My Zsh Config
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Enable colors in terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Aliases
alias ll="ls -la"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"

# Powerlevel10k prompt (run `p10k configure` to customize)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

# Apply changes
source ~/.zshrc

echo "✅ Done! iTerm2 + Oh My Zsh + Plugins installed."
echo "Run 'p10k configure' to customize your prompt, then restart iTerm2."
