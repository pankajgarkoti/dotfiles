if vim.g.neovide then
	vim.o.guifont = "IosevkaTerm Nerd Font Mono:h16"
	vim.g.neovide_text_contrast = 0.7

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	-- set minimum neovide window size
	vim.g.neovide_size = 0.6

	-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
	vim.g.neovide_window_blurred = false
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	vim.g.neovide_position_animation_length = 0.05
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_scroll_animation_far_lines = 0
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_theme = 'auto'
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_no_idle = true
	vim.g.neovide_confirm_quit = true
	vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
	vim.g.neovide_cursor_trail_size = 0.1
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
end
