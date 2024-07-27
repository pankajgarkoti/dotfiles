# Dotfiles for Neovim, iTerm, Zsh and Tmux

## Install

*It is always a good idea to backup your existing dotfiles before goofing around with them.*

```bash
git clone https://github.com/pankajgarkoti/dotfiles.git

cd dotfiles

# backup any files that could be overwritten
backup_dirs=(
    "~/.config/nvim"
    "~/.tmux"
    "~/powerlevel10k"
    "~/itermcolors"
)

backup_files=(
    "~/.zshrc"
    "~/.tmux.conf"
    "/.p10k.zsh"
    "~/.zshenv"
    "iterm-default.json"
)

for dir in "${backup_dirs[@]}"; do
    if [ -d "$dir" ]; then
        cp -r "$dir" "$dir.bak"
    fi
done

for file in "${backup_files[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
    fi
done

# Check is GNU Stow installed.
# If it is not installed, we will try to install it using Homebrew.
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed. Trying to install it using Homebrew..."
    brew install stow
    if ! command -v stow &> /dev/null; then
        echo "GNU Stow installation failed. Please install it manually."
        exit 1
    fi
fi

targets = (
    "nvim"
    "iterm"
    "zsh"
    "tmux"
)

for target in "${targets[@]}"; do
    echo "Installing: $target"
    stow $target
done
```

## Uninstall

*Just remove the dotfiles???*
