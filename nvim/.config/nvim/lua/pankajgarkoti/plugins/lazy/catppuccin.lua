return {
	"catppuccin/nvim",
	name = "catppuccin",
	enabled = true,
	priority = 1001,
	lazy = false,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
		})
		vim.cmd("colorscheme catppuccin-mocha")
	end
}
