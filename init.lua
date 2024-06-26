-- Core
require("pankajgarkoti.plugins-setup")
require("pankajgarkoti.core.options")
require("pankajgarkoti.core.keymaps")

-- Plugins
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

-- Patches
local opts = { noremap = true, silent = true }
-- Patch for codeium interfering with autocomplete popup behaviour
-- vim.g.codeium_no_map_tab = 1
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set wrap",
})
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require('telescope.builtin').find_files()
	end
})


local function quickfix()
	vim.lsp.buf.code_action({
		filter = function(a) return a ~= nil end,
		apply = true
	})
end

vim.keymap.set('n', '<leader>qf', quickfix, opts)
