local setup, nvimtree = pcall(require, "nvim-tree")

if not setup then
	return
end

-- recommended settings from nvimtree docs
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

local HEIGHT_RATIO = 0.7 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

nvimtree.setup({
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- arrow when folder is closed
					arrow_open = "", -- arrow when folder is open
				},
			},
		},
	},
	actions = {
		open_file = {
			window_picker = {
				enable = true,
			},
		},
	},
	view = {
		side = "left",
		width = 30,
		preserve_window_proportions = true,
	},
})
