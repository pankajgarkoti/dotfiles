-- enable wrapping on every buffer
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set wrap",
})

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

local colorscheme_imports = {
	material = "pankajgarkoti.core.colorscheme_material",
	onedark = "pankajgarkoti.core.colorscheme_onedark",
	catppuccin = "pankajgarkoti.core.colorscheme_catppuccin",
	gruvbox = "pankajgarkoti.core.colorscheme_gruvbox",
}

local colorscheme = nil
local colorscheme_import = nil
local env_colorscheme = nil

-- set colorscheme here
colorscheme = "catppuccin-frappe"
colorscheme_import = colorscheme_imports.gruvbox
env_colorscheme = os.getenv("NVIM_COLORSCHEME")

if colorscheme then
	vim.cmd("colorscheme " .. colorscheme)
elseif colorscheme_import then
	require(colorscheme_import)
elseif env_colorscheme then
	vim.cmd("colorscheme " .. env_colorscheme)
else
	vim.cmd("colorscheme catppuccin-mocha")
end


-- vim.opt.termguicolors = true
-- vim.cmd("set termguicolors")
-- vim.cmd("set background=dark")
-- vim.cmd("set conceallevel=2")
-- vim.cmd("highlight Cursor guibg=#ffffff guifg=#000000")
-- vim.cmd("set guicursor=a:hor30-Cursor-blinkon0,i:hor30-Cursor-blinkon2")
-- vim.cmd("set nocursorline")

vim.opt.termguicolors = true
vim.cmd("set termguicolors")
vim.cmd("set background=dark")
vim.cmd("set conceallevel=2")
vim.cmd("set guicursor=a:hor50-Cursor-blinkon0")
vim.cmd("highlight Cursor guifg=#000000 guibg=#ffffff")
vim.cmd("set nocursorline")

--- @return string
--- Get the path to the python executable in the current virtual environment.
--- If the current directory is not in a virtual environment, return python3 default path.
--- The path is determined by running `which python3` in the current directory.
local get_venv_python_path = function()
	local path = ""
	local command = vim.system({ "which" }, { "python3" })
	command.write(command, path)
	local should_return_default = (path == nil) or (path == "")
	if should_return_default then
		return "python3"
	else
		return path
	end
end

vim.g.python3_host_prog = get_venv_python_path()

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
