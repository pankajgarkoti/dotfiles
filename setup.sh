#!/bin/bash

set -e

echo "🔧 Setting up dotfiles..."
echo

# Backup existing files and directories
echo "📋 Creating backups..."

backup_dirs=(
    "$HOME/.config/nvim"
    "$HOME/.tmux"
    "$HOME/powerlevel10k"
    "$HOME/itermcolors"
)

backup_files=(
    "$HOME/.zshrc"
    "$HOME/.tmux.conf"
    "$HOME/.p10k.zsh"
    "$HOME/.zshenv"
    "$HOME/iterm-default.json"
)

for dir in "${backup_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "  Backing up $dir to $dir.bak"
        cp -r "$dir" "$dir.bak"
    fi
done

for file in "${backup_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  Backing up $file to $file.bak"
        cp "$file" "$file.bak"
    fi
done

# Check if GNU Stow is installed
echo "🔍 Checking for GNU Stow..."
if ! command -v stow &> /dev/null; then
    echo "  GNU Stow is not installed. Trying to install it using Homebrew..."
    if command -v brew &> /dev/null; then
        brew install stow
    else
        echo "  ❌ Homebrew not found. Please install GNU Stow manually."
        echo "  You can install it with:"
        echo "    - macOS: brew install stow"
        echo "    - Ubuntu/Debian: sudo apt install stow"
        echo "    - Arch: sudo pacman -S stow"
        exit 1
    fi
    
    if ! command -v stow &> /dev/null; then
        echo "  ❌ GNU Stow installation failed. Please install it manually."
        exit 1
    fi
fi
echo "  ✅ GNU Stow found"

# Clone Powerlevel10k theme if not already present
echo "🎨 Setting up Powerlevel10k..."
if [ ! -d "zsh/powerlevel10k" ]; then
    echo "  Cloning Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git zsh/powerlevel10k
    echo "  ✅ Powerlevel10k cloned successfully"
else
    echo "  ✅ Powerlevel10k already exists"
fi

# Install dotfiles using Stow
echo "📦 Installing dotfiles..."
targets=(
    "nvim"
    "iterm"
    "zsh"
    "tmux"
    "lazygit"
    "alacritty"
    "claude"
)

for target in "${targets[@]}"; do
    if [ -d "$target" ]; then
        echo "  Installing: $target"
        stow "$target"
    else
        echo "  ⚠️  Skipping $target (directory not found)"
    fi
done

echo
echo "🎉 Setup complete!"
echo
echo "📝 Next steps:"
echo "  1. Restart your terminal"
echo "  2. Run 'p10k configure' to set up Powerlevel10k"
echo "  3. Or reload your shell: source ~/.zshrc"
echo
echo "💡 If you encounter any issues, check the backup files created above."