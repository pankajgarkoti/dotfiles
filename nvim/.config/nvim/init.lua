-- Core
require("pankajgarkoti.plugins-setup")
require("pankajgarkoti.core.options")
require("pankajgarkoti.core.keymaps")
require("pankajgarkoti.core.colorscheme_material")

-- plugins
require("pankajgarkoti.plugins.comment")
require("pankajgarkoti.plugins.nvim-tree")
require("pankajgarkoti.plugins.telescope")
require("pankajgarkoti.plugins.treesitter")
require("pankajgarkoti.plugins.gitsigns")
require("pankajgarkoti.plugins.fterm")
require("pankajgarkoti.plugins.no-neck-pain")
require("pankajgarkoti.plugins.notify")
require("pankajgarkoti.plugins.blamer")
require("pankajgarkoti.plugins.xcodebuild")
require("pankajgarkoti.plugins.harpoon")
require("pankajgarkoti.plugins.autopairs")

-- LSP ad-hoc config
require("pankajgarkoti.plugins.lsp.eslint-lspconfig")

-- enable wrapping on every buffer
local opts = { noremap = true, silent = true }
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set wrap",
})

vim.opt.termguicolors = true
vim.cmd("set background=dark")
vim.cmd("set conceallevel=2")

if vim.g.neovide then
	vim.o.guifont = "IosevkaTerm Nerd Font Mono:h16"
	vim.g.neovide_text_contrast = 0.7

	vim.g.neovide_padding_top = 0
	vim.g.neovide_padding_bottom = 0
	vim.g.neovide_padding_right = 0
	vim.g.neovide_padding_left = 0

	-- set minimum neovide window size
	vim.g.neovide_size = 0.6

	-- Helper function for transparency formatting
	local alpha = function()
		local tranparency_fraction = vim.g.transparency or 0.8
		local transparency = math.floor(255 * tranparency_fraction)

		return string.format("%x", transparency)
	end

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
