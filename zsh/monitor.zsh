#!/bin/zsh

# Script to switch alacritty font size and background color when I'm working on my home monitor

set -e

ALACRITTY_CONFIG="$HOME/dotfiles/alacritty/.config/alacritty.toml"

# Display usage information and available commands
# Outputs help text to stdout showing script usage, subcommands, and options
# Arguments: None
# Returns: None (outputs to stdout)
usage() {
	echo "Usage: $0 [subcommand] [options]"
	echo "Subcommands:"
	echo "  toggle      - toggles the monitor configuration (font and background)"
	echo "  bg          - toggles the background color"
	echo "  font [size] - toggles font size, or sets to [size]"
	echo "  status      - shows current monitor configuration"
	echo "Options:"
	echo "  -h, --help - display this help message"
}

# Display current monitor configuration status
# Shows current font size and background setting from Alacritty config
# Arguments: None
# Returns: None (outputs current status to stdout)
status() {
	if grep -q "size = 16" "$ALACRITTY_CONFIG"; then
		echo "Current mode: Laptop (font size 16)"
		if grep -q "# background = '#000000'" "$ALACRITTY_CONFIG"; then
			echo "Background: Default (commented)"
		else
			echo "Background: Black (uncommented)"
		fi
	elif grep -q "size = 22" "$ALACRITTY_CONFIG"; then
		echo "Current mode: External Monitor (font size 22)"
		if grep -q "# background = '#000000'" "$ALACRITTY_CONFIG"; then
			echo "Background: Theme default (override is commented)"
		else
			echo "Background: Black (override is uncommented)"
		fi
	else
		# Extract current font size
		current_size=$(grep "size = " "$ALACRITTY_CONFIG" | head -1 | sed 's/.*size = \([0-9]*\).*/\1/')
		if [[ -n "$current_size" ]]; then
			echo "Current mode: Unknown (font size $current_size)"
		else
			echo "Current mode: Unknown (font size not found)"
		fi
		if grep -q "^[[:space:]]*background = " "$ALACRITTY_CONFIG"; then
			background_color=$(grep "^[[:space:]]*background = " "$ALACRITTY_CONFIG" | head -1 | sed "s/.*background = '\([^']*\)'.*/\1/")
			echo "Background: $background_color (uncommented)"
		elif grep -q "^[[:space:]]*# background = " "$ALACRITTY_CONFIG"; then
			background_color=$(grep "^[[:space:]]*# background = " "$ALACRITTY_CONFIG" | head -1 | sed "s/.*# background = '\([^']*\)'.*/\1/")
			echo "Background: $background_color (commented)"
		else
			echo "Background: Not found in config"
		fi
	fi
}

# Toggle between two monitor configurations by modifying Alacritty config
# Switches between:
#   - Font size 16 with commented background (laptop mode)
#   - Font size 22 with uncommented black background (external monitor mode)
# Arguments: None
# Returns: None
# Side effects: Modifies the Alacritty configuration file in-place
toggle() {
	if grep -q "size = 16" "$ALACRITTY_CONFIG"; then
		# Change font size to 22 and uncomment background
		sed -i '' 's/size = 16/size = 22/' "$ALACRITTY_CONFIG"
		sed -i '' "s/# background = '#000000'/background = '#000000'/" "$ALACRITTY_CONFIG"
		echo "Switched to: External Monitor mode (font size 22, black background)"
	else
		# Change font size to 16 and comment background
		sed -i '' 's/size = 22/size = 16/' "$ALACRITTY_CONFIG"
		sed -i '' "s/background = '#000000'/# background = '#000000'/" "$ALACRITTY_CONFIG"
		echo "Switched to: Laptop mode (font size 16, theme default background)"
	fi
}

# Toggle Alacritty background color
# Switches between default theme background and black background
# Arguments: None
# Returns: None
# Side effects: Modifies the Alacritty configuration file in-place
toggle_bg() {
    if grep -q "# background = '#000000'" "$ALACRITTY_CONFIG"; then
        # Uncomment background
        sed -i '' "s/# background = '#000000'/background = '#000000'/" "$ALACRITTY_CONFIG"
        echo "Switched to: Black background"
    else
        # Comment background
        sed -i '' "s/background = '#000000'/# background = '#000000'/" "$ALACRITTY_CONFIG"
        echo "Switched to: Theme default background"
    fi
}

# Toggle Alacritty font size
# Switches between font size 16 (laptop) and 22 (external monitor)
# Or sets a specific font size if provided
# Arguments:
#   $1 (optional) - The font size to set
# Returns: None
# Side effects: Modifies the Alacritty configuration file in-place
toggle_font() {
    if [ -n "$1" ]; then
        # Set to specific size
        current_size=$(grep "size = " "$ALACRITTY_CONFIG" | head -1 | sed 's/.*size = \([0-9]*\).*/\1/')
        sed -i '' "s/size = $current_size/size = $1/" "$ALACRITTY_CONFIG"
        echo "Switched to: Font size $1"
    else
        # Toggle between 16 and 22
        if grep -q "size = 16" "$ALACRITTY_CONFIG"; then
            # Change font size to 22
            sed -i '' 's/size = 16/size = 22/' "$ALACRITTY_CONFIG"
            echo "Switched to: Font size 22 (External Monitor)"
        else
            # Change font size to 16
            sed -i '' 's/size = 22/size = 16/' "$ALACRITTY_CONFIG"
            echo "Switched to: Font size 16 (Laptop)"
        fi
    fi
}


# Main function to handle command line arguments and execute appropriate actions
# Processes command line arguments and calls corresponding functions
# If no arguments provided, defaults to toggle action
# Arguments: All command line arguments passed to script ($@)
# Returns:
#   - 0 on successful execution
#   - 1 on invalid arguments (calls usage and exits)
main() {
	if [ $# -eq 0 ]; then
		toggle
		exit 0
	fi

	while [ $# -gt 0 ]; do
		case "$1" in
		toggle)
			toggle
			shift
			;;
        bg)
            toggle_bg
            shift
            ;;
        font)
            toggle_font "$2"
            if [ -n "$2" ]; then
                shift
            fi
            shift
            ;;
		status)
			status
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			usage
			exit 1
			;;
		esac
	done
}

main "$@"