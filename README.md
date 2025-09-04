# Dotfiles for Neovim, iTerm, Zsh and Tmux

## Install

_It is always a good idea to backup your existing dotfiles before goofing around with them._

### Quick Setup

```bash
git clone https://github.com/pankajgarkoti/dotfiles.git
cd dotfiles
./setup.sh
```

### Manual Setup

If you prefer to install manually or want to understand what the setup script does:

```bash
git clone https://github.com/pankajgarkoti/dotfiles.git
cd dotfiles

# The setup script handles:
# - Creating backups of existing dotfiles
# - Installing GNU Stow (if not present)
# - Cloning Powerlevel10k theme
# - Using Stow to symlink all configurations

# You can also run individual steps:
brew install stow  # Install GNU Stow
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git zsh/powerlevel10k
stow nvim iterm zsh tmux lazygit alacritty
```

After installation, restart your terminal and run `p10k configure` to set up Powerlevel10k.

## Uninstall

_Just remove the dotfiles???_
