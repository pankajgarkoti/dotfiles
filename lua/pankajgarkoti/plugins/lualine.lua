local setup, lualine = pcall(require, "lualine")
if not setup then
	return
end

local lualine_nightfly = require("lualine.themes.nightfly")

-- new colors for theme
local new_colors = {
	blue = "#65D1FF",
	green = "#3EFFDC",
	violet = "#FF61EF",
	yellow = "#FFDA7B",
	black = "#000000",
}

lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black,
	},
}

lualine.setup({
	options = {
		theme = "material",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{ "buffers", icons_enabled = true },
		},
		lualine_c = {},
		lualine_x = { "branch", "diff" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})
