return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",                                                                  -- Optional: For using slash commands and variables in the chat buffer
		"nvim-telescope/telescope.nvim",                                                     -- Optional: For using slash commands
		{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
		{ "stevearc/dressing.nvim",                    opts = {} },                          -- Optional: Improves `vim.ui.select`
	},
	opts = {
		strategies = {
			chat = {
				adapter = "anthropic",
			},
			inline = {
				adapter = "anthropic",
			},
			agent = {
				adapter = "anthropic",
			},
		},
		opts = { log_level = "INFO" },
		display = {
			chat = {
				show_settings = true,
			}
		},
		adapters = {
			anthropic = function()
				return require("codecompanion.adapters").extend("anthropic", {
					schema = {
						model = {
							default = "claude-sonnet-4-20250514",
						},
					},
				})
			end,
		},
	},
}
