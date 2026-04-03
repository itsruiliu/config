#!/bin/bash
set -euo pipefail

# ====== Install packages ======
brew install --cask font-meslo-lg-nerd-font
brew install fzf direnv zoxide uv

# Zsh plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true

# ====== Setup symlinks safely ======

DOTFILES_DIR="$(pwd)"

# Verify we're in correct directory
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  echo "Error: Please run this script from your dotfiles repository root!"
  exit 1
fi

# Backup existing dotfiles to a timestamped directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo "Backing up existing files to $BACKUP_DIR..."

# Function to safely symlink files/directories
symlink_dotfile() {
  local src="$1"
  local dst="$2"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "Backing up $(basename "$dst")"
    mv "$dst" "$BACKUP_DIR/"
  fi

  echo "Creating symlink: $dst -> $src"
  ln -s "$src" "$dst"

  if [ -L "$dst" ]; then
    echo "✅ Created symlink: $(basename "$dst")"
  else
    echo "❌ Failed to create symlink: $(basename "$dst")"
  fi
}

# Symlink .zshrc and .wezterm.lua
symlink_dotfile "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
symlink_dotfile "$DOTFILES_DIR/.wezterm.lua" "$HOME/.wezterm.lua"

echo "🎉 Dotfiles setup completed!"
