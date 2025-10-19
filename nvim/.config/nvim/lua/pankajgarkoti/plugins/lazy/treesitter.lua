return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
		ts_update()
	end,
	dependencies = {
		"nvim-treesitter/playground",
		"nvim-treesitter/nvim-treesitter-textobjects",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin safely
		local status, ts_config = pcall(require, "nvim-treesitter.configs")
		if not status then
			return
		end

		ts_config.setup({
			highlight = { enable = true },
			indent = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"lua",
				"markdown",
				"markdown_inline",
				"yaml",
				"json",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"markdown",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore"
			},
			auto_install = true,
		})
	end
}
