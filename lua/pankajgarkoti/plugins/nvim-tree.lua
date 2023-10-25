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
	-- view = {
	-- 	side = "left",
	-- 	width = 36,
	-- 	preserve_window_proportions = true,
	-- },
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
})
