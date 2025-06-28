#!/bin/zsh

ALACRITTY_CONFIG="/Users/pankajgarkoti/dotfiles/alacritty/.config/alacritty.toml"

if grep -q "size = 16" "$ALACRITTY_CONFIG"; then
  # Change font size to 22 and uncomment background
  sed -i '' 's/size = 16/size = 22/' "$ALACRITTY_CONFIG"
  sed -i '' "s/# background = '#000000'/background = '#000000'/" "$ALACRITTY_CONFIG"
else
  # Change font size to 16 and comment background
  sed -i '' 's/size = 22/size = 16/' "$ALACRITTY_CONFIG"
  sed -i '' "s/background = '#000000'/# background = '#000000'/" "$ALACRITTY_CONFIG"
fi
