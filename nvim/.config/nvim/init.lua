-- enable wrapping on every buffer
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set wrap",
})

-- Core
require("pankajgarkoti.plugins-setup")
require("pankajgarkoti.core.keymaps")
require("pankajgarkoti.core.options")

-- plugins
require("pankajgarkoti.plugins.nvim-tree")
require("pankajgarkoti.plugins.treesitter")
require("pankajgarkoti.plugins.gitsigns")
require("pankajgarkoti.plugins.fterm")
require("pankajgarkoti.plugins.no-neck-pain")
require("pankajgarkoti.plugins.autopairs")
require("pankajgarkoti.plugins.diffview")

-- LSP ad-hoc config
require("pankajgarkoti.plugins.lsp.eslint-lspconfig")

-- autocmds
require("pankajgarkoti.core.autocmds")


-- cursor and termguicolors
vim.opt.termguicolors = true
vim.cmd("set background=dark")
vim.cmd("set termguicolors")
vim.cmd("set conceallevel=2")
vim.cmd("set guicursor=n-v-c:block-Cursor/lCursor-blinkon0")
vim.cmd("highlight Cursor guifg=#000000 guibg=#ffffff")
vim.cmd("set nocursorline")
