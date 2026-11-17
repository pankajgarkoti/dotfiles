-- nvim-treesitter (main branch) is used only as a parser/query manager.
-- Highlighting itself is started natively via the FileType autocmd in init.lua.
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		-- Install any missing parsers for the filetypes we highlight natively.
		-- Already-installed parsers are skipped, so this is cheap on startup.
		require("nvim-treesitter").install({
			"lua", "markdown", "markdown_inline", "yaml", "json", "python",
			"javascript", "typescript", "tsx",
			"html", "css", "svelte", "graphql", "bash",
			"vim", "vimdoc", "dockerfile", "gitignore",
		})
	end,
}
