-- Core
require("pankajgarkoti.core.keymaps")
require("pankajgarkoti.plugins.setup")
require("pankajgarkoti.core.options")

-- LSP ad-hoc config
-- require("pankajgarkoti.plugins.lsp.eslint-lspconfig")

-- autocmds
require("pankajgarkoti.core.autocmds")
require("pankajgarkoti.core.cmds")
-- require("pankajgarkoti.core.ts-native")

-- Utils & Prefs
require("pankajgarkoti.prefs.path_utils")

-- fix for floating window borders bg color mismatch
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })

-- treesitter native
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua", "markdown", "yaml", "json", "python",
		"javascript", "typescript", "typescriptreact",
		"html", "css", "svelte", "graphql", "bash",
		"vim", "dockerfile", "gitignore"
	},
	callback = function()
		-- Start native highlighting
		vim.treesitter.start()

		-- Enable native folding via treesitter (optional but recommended)
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
