local setup, nvimtree = pcall(require, "nvim-tree")

if not setup then
	return
end

-- recommended settings from nvimtree docs
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 80
local height = 40

nvimtree.setup({
	hijack_cursor = true,
	sync_root_with_cwd = true,
	view = {
		preserve_window_proportions = true,
		centralize_selection = true,
		float = {
			enable = true,
			open_win_config = {
				relative = "editor",
				width = width,
				height = height,
				row = (gheight - height) * 0.4,
				col = (gwidth - width) * 0.5,
			},
		},
	},
	renderer = {
		full_name = true,
		group_empty = true,
		special_files = {},
		symlink_destination = false,
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = false,
				git = true,
			},
		},
	},
	update_focused_file = {
		enable = true,
		update_root = true,
		ignore_list = { "help" },
	},
	diagnostics = {
		enable = false,
		show_on_dirs = false,
	},
	actions = {
		change_dir = {
			enable = false,
			restrict_above_cwd = false,
		},
		open_file = {
			resize_window = false,
			window_picker = {
				chars = "aoeui",
			},
		},
		remove_file = {
			close_window = false,
		},
	},
	log = {
		enable = false,
		truncate = true,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			diagnostics = false,
			git = false,
			profile = false,
			watcher = false,
		},
	},
})
