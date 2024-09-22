require("material").setup({
	contrast = {
		terminal = true,           -- Enable contrast for the built-in terminal
		sidebars = true,           -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
		floating_windows = true,   -- Enable contrast for floating windows
		cursor_line = true,        -- Enable darker background for the cursor line
		non_current_windows = false, -- Enable darker background for non-current windows
		filetypes = {},            -- Specify which filetypes get the contrasted (darker) background
	},

	styles = { -- Give comments style such as bold, italic, underline etc.
		comments = {},
		strings = { italic = true },
		keywords = {},
		functions = { bold = true },
		variables = { italic = true },
		operators = {},
		types = { bold = true },
	},

	plugins = { -- Uncomment the plugins that you use to highlight them
		"gitsigns",
		"indent-blankline",
		"nvim-tree",
		"nvim-web-devicons",
		"telescope",
	},

	disable = {
		colored_cursor = true, -- Disable the colored cursor
		borders = false,     -- Disable borders between verticaly split windows
		background = true,   -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
		term_colors = false, -- Prevent the theme from setting terminal colors
		eob_lines = false,   -- Hide the end-of-buffer lines
	},

	high_visibility = {
		lighter = false, -- Enable higher contrast text for lighter style
		-- darker = false -- Enable higher contrast text for darker style
		darker = true, -- Enable higher contrast text for darker style
	},

	lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
	-- lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
	async_loading = true,     -- Load parts of the theme asyncronously for faster startup (turned on by default)
	custom_colors = nil,      -- If you want to everride the default colors, set this to a function

	custom_highlights = {
		--		TabLineSel = { bg = C.pink },
		--		CmpBorder = { fg = C.surface2 },
		PmenuSel = { bg = "#000000" },
		TelescopeBorder = { link = "FloatBorder" },
	},
})

-- vim.g.material_style = "palenight"
-- vim.g.material_style = "deep ocean"
vim.g.material_style = "darker"
vim.cmd("colorscheme material-darker")
