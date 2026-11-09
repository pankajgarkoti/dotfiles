# Bash port of alacritty_theme.zsh: preview and set Alacritty themes using fzf

# Point the config's import line at a theme.
# Arguments: $1 - theme name, $2 - config file
_alacritty_theme_apply() {
	local line="import = [\"~/.config/alacritty/themes/themes/$1.toml\"]"
	if sed --version >/dev/null 2>&1; then
		sed -i "s|^import = .*|$line|" "$2"
	else
		sed -i '' "s|^import = .*|$line|" "$2"
	fi
}

alacritty-theme() {
	local themes_dir="$HOME/dotfiles/alacritty/.config/alacritty/themes/themes"
	local config_file="$HOME/dotfiles/alacritty/.config/alacritty.toml"

	# Check if themes directory exists
	if [[ ! -d "$themes_dir" ]]; then
		echo "Themes directory not found at $themes_dir"
		return 1
	fi

	# If theme name provided directly, apply it without preview
	if [[ -n "$1" ]]; then
		if [[ ! -f "$themes_dir/$1.toml" ]]; then
			echo "Theme '$1' not found."
			return 1
		fi
		cp "$config_file" "${config_file}.bak"
		_alacritty_theme_apply "$1" "$config_file"
		echo "Theme set to '$1'. Config updated."
		return
	fi

	# Check if fzf is installed
	if ! command -v fzf &>/dev/null; then
		echo "fzf is not installed. Please install it first."
		return 1
	fi

	# Get current theme from config to restore if needed
	local current_theme
	current_theme=$(sed -nE 's|^import = .*themes/themes/(.*)\.toml.*|\1|p' "$config_file" | head -n1)

	# Create a backup of the current config
	cp "$config_file" "${config_file}.bak"

	# fzf runs its preview in a separate shell, so this can't call the function above
	local sed_i="sed -i"
	sed --version >/dev/null 2>&1 || sed_i="sed -i ''"

	# Restore the original theme if interrupted. Unlike zsh, a bash EXIT trap set
	# here would fire when the shell exits, not when this function returns.
	trap '_alacritty_theme_apply "'"$current_theme"'" "'"$config_file"'"' INT TERM

	# Use fzf for interactive selection with live preview
	local selected_theme
	selected_theme=$(find "$themes_dir" -name "*.toml" | sed 's|.*/||' | sed 's|\.toml$||' | sort |
		fzf --preview "cat \"$themes_dir\"/{}.toml; $sed_i 's|^import = .*|import = [\"~/.config/alacritty/themes/themes/'{}'.toml\"]|' \"$config_file\"" \
			--height 80% \
			--layout=reverse \
			--border \
			--prompt="Current: $current_theme > " \
			--header "Select an Alacritty theme (↑/↓: Navigate, Enter: Select, ESC: Cancel)" \
			--ansi \
			--bind "left:preview-page-up" \
			--bind "right:preview-page-down" \
			--bind "ctrl-p:toggle-preview" \
			--query="$current_theme")
	trap - INT TERM

	if [[ -n "$selected_theme" ]]; then
		_alacritty_theme_apply "$selected_theme" "$config_file"
		echo "Theme set to '$selected_theme'. Config updated."
	else
		# No theme selected (ESC was pressed), restore original
		_alacritty_theme_apply "$current_theme" "$config_file"
		echo "Restored original theme: $current_theme"
	fi
}

# Add completion for alacritty-theme
_alacritty_theme_completion() {
	local themes_dir="$HOME/dotfiles/alacritty/.config/alacritty/themes/themes"
	[[ -d "$themes_dir" ]] || return
	local themes
	themes=$(find "$themes_dir" -name "*.toml" | sed 's|.*/||' | sed 's|\.toml$||' | sort)
	COMPREPLY=($(compgen -W "$themes" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _alacritty_theme_completion alacritty-theme
