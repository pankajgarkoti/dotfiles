local exists, _ = pcall(require, "catppuccin")

if not exists then
	print("Catpuccin theme not found")
	return
end

require("catppuccin").setup({
	-- flavor = "macchiato",
	flavour = "mocha",
	-- flavour = "latte",
	background = {
		light = "mocha",
		dark = "mocha",
	},
	-- background = {
	-- 	light = "macchiato",
	-- 	dark = "macchiato",
	-- },
	transparent_background = false,
	show_end_of_buffer = true, -- show the '~' characters after the end of buffers
	term_colors = true,
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {},
	custom_highlights = {},
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		telescope = true,
		notify = true,
		mini = false,
	},
	telescope = {
		enabled = true,
		border = true,
	},
	cmp = {
		enabled = true,
		border = true,
	},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
