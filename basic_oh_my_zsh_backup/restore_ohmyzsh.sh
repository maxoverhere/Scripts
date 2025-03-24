#!/bin/zsh

echo "🔵 Restoring Oh My Zsh config..."

# Restore .zshrc
[ -f .zshrc ] && cp .zshrc ~/.zshrc

# Restore Powerlevel10k config
[ -f .p10k.zsh ] && cp .p10k.zsh ~/.p10k.zsh

# Restore custom plugins and themes
[ -f ohmyzsh_custom.tar.gz ] && tar -xzvf ohmyzsh_custom.tar.gz -C ~/.oh-my-zsh

echo "✅ Restoration complete! Restart your terminal."
