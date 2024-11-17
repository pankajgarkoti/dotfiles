-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = true,
		comments = true,
		operators = false,
		folds = true,
	},
	strikethrough = true,
	invert_selection = true,
	invert_signs = true,
	invert_tabline = true,
	invert_intend_guides = false,
	inverse = true,   -- invert background for search, diffs, statuslines and errors
	contrast = "hard", -- can be "hard", "soft" or empty string
	palette_overrides = {},
	dim_inactive = false,
	transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
