return {
	'MeanderingProgrammer/render-markdown.nvim',
	enabled = true,
	opts = {},
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
	config = function()
		require("render-markdown").setup({
			completions = { lsp = { enabled = true } },
			render_modes = { "n", "v", "i" },
			preset = "obsidian",
			anti_conceal = {
				enabled = false,
			},
		})
	end
}
