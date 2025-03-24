#!/bin/zsh

# Backup Oh My Zsh configuration
echo "🔵 Backing up Oh My Zsh config..."

# Create backup directory
BACKUP_DIR="$HOME/ohmyzsh_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup critical files
cp ~/.zshrc "$BACKUP_DIR/.zshrc"
[ -f ~/.p10k.zsh ] && cp ~/.p10k.zsh "$BACKUP_DIR/.p10k.zsh"

# Backup custom plugins and themes
if [ -d ~/.oh-my-zsh/custom ]; then
    tar -czvf "$BACKUP_DIR/ohmyzsh_custom.tar.gz" -C ~/.oh-my-zsh custom
fi

# Create restore script
cat > "$BACKUP_DIR/restore_ohmyzsh.sh" << 'EOL'
#!/bin/zsh

echo "🔵 Restoring Oh My Zsh config..."

# Restore .zshrc
[ -f .zshrc ] && cp .zshrc ~/.zshrc

# Restore Powerlevel10k config
[ -f .p10k.zsh ] && cp .p10k.zsh ~/.p10k.zsh

# Restore custom plugins and themes
[ -f ohmyzsh_custom.tar.gz ] && tar -xzvf ohmyzsh_custom.tar.gz -C ~/.oh-my-zsh

echo "✅ Restoration complete! Restart your terminal."
EOL

chmod +x "$BACKUP_DIR/restore_ohmyzsh.sh"

echo "✅ Backup complete! Files saved to:"
echo "   $BACKUP_DIR"
echo "To restore, run:"
echo "   cd $BACKUP_DIR && ./restore_ohmyzsh.sh"
