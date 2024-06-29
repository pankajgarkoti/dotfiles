-- core
require("pankajgarkoti.plugins-setup")
require("pankajgarkoti.core.options")
require("pankajgarkoti.core.keymaps")

-- plugins
require("pankajgarkoti.plugins.comment")
require("pankajgarkoti.plugins.nvim-tree")
require("pankajgarkoti.plugins.telescope")
require("pankajgarkoti.plugins.treesitter")
require("pankajgarkoti.plugins.gitsigns")
require("pankajgarkoti.plugins.fterm")
require("pankajgarkoti.plugins.no-neck-pain")
require("pankajgarkoti.plugins.noice")
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


vim.cmd.colorscheme("catppuccin-latte")
