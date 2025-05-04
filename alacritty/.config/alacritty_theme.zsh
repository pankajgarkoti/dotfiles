# Function to preview and set Alacritty themes using fzf with live preview
alacritty-theme() {
	local themes_dir="$HOME/dotfiles/alacritty/.config/alacritty/themes/themes"
	local config_file="$HOME/dotfiles/alacritty/.config/alacritty.toml"

	# Check if fzf is installed
	if ! command -v fzf &>/dev/null; then
		echo "fzf is not installed. Please install it first."
		return 1
	fi

	# Check if themes directory exists
	if [[ ! -d "$themes_dir" ]]; then
		echo "Themes directory not found at $themes_dir"
		return 1
	fi

	# Get current theme from config to restore if needed
	local current_theme=$(grep -o "themes/themes/.*\.toml" "$config_file" | sed 's|themes/themes/||' | sed 's|\.toml||')

	# Create a backup of the current config
	cp "$config_file" "${config_file}.bak"

	# Function to apply theme temporarily (for preview)
	preview_theme() {
		local theme="$1"
		local theme_path="~/.config/alacritty/themes/themes/$theme.toml"

		# debug print all arguments
		echo "preview_theme() called with args: $@"

		# Update the theme import in the config file
		sed -i '' "s|~/.config/alacritty/themes/themes/.*\.toml|~/.config/alacritty/themes/themes/$theme.toml|" "$config_file"
		echo "Previewing: $theme" >/dev/stderr
	}

	# Function to restore original theme
	restore_original() {
		local theme_path="~/.config/alacritty/themes/themes/$current_theme.toml"
		sed -i '' "s|~/.config/alacritty/themes/themes/.*\.toml|~/.config/alacritty/themes/themes/$current_theme.toml|" "$config_file"
		echo "Restored original theme: $current_theme"
	}

	# Trap interruptions to restore original theme
	trap restore_original INT TERM EXIT

	# If theme name provided directly, apply it without preview
	if [[ -n "$1" ]]; then
		local theme_file="$themes_dir/$1.toml"
		if [[ ! -f "$theme_file" ]]; then
			echo "Theme '$1' not found."
			return 1
		fi
		preview_theme "$1"
		# Remove the trap since we applied the theme directly
		trap - INT TERM EXIT
		echo "Theme set to '$1'. Config updated."
		return
	fi

	# Use fzf for interactive selection with live preview
	local selected_theme=$(find "$themes_dir" -name "*.toml" | sed 's|.*/||' | sed 's|\.toml$||' | sort |
		fzf --preview "cat $themes_dir/{}.toml; sed -i '' 's/.\.toml/{}.toml/g' $config_file" \
			--height 80% \
			--layout=reverse \
			--border \
			--prompt="Current: $current_theme > " \
			--header "Select an Alacritty theme (↑/↓: Navigate, Enter: Select, ESC: Cancel)" \
			--ansi \
			--bind "up:up+execute(echo $@)" \
			--bind "down:down+execute(echo $@)')" \
			--bind "change:execute(echo $@)" \
			--bind "left:preview-page-up" \
			--bind "right:preview-page-down" \
			--bind "ctrl-p:toggle-preview" \
			--query="$current_theme")

	# Check if a theme was selected
	if [[ -n "$selected_theme" ]]; then
		# Theme was selected with Enter, keep it
		preview_theme "$selected_theme"
		# Remove the trap since we're keeping the selected theme
		trap - INT TERM EXIT
		echo "Theme set to '$selected_theme'. Config updated."
	else
		# No theme selected (ESC was pressed), restore original
		restore_original
	fi
}

# Add completion for alacritty-theme
_alacritty_theme_completion() {
	local themes_dir="$HOME/dotfiles/alacritty/.config/alacritty/themes/themes"
	if [[ -d "$themes_dir" ]]; then
		local themes=$(find "$themes_dir" -name "*.toml" | sed 's|.*/||' | sed 's|\.toml$||' | sort)
		_arguments "1: :($themes)"
	fi
}

compdef _alacritty_theme_completion alacritty-theme
