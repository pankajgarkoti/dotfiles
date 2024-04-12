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
--
-- nvimtree.setup({
-- 	renderer = {
-- 		icons = {
-- 			glyphs = {
-- 				folder = {
-- 					arrow_closed = "", -- arrow when folder is closed
-- 					arrow_open = "", -- arrow when folder is open
-- 				},
-- 			},
-- 		},
-- 	},
--   filters = {
--     dotfiles = true,
--   },
-- 	actions = {
-- 		open_file = {
-- 			window_picker = {
-- 				enable = true,
-- 			},
-- 		},
-- 	},
-- 	view = {
-- 		preserve_window_proportions = true,
-- 		width = 34,
-- 		float = {
-- 			enable = true,
-- 			open_win_config = {
-- 				relative = "editor",
-- 				width = width,
-- 				height = height,
-- 				row = (gheight - height) * 0.4,
-- 				col = (gwidth - width) * 0.5,
-- 			},
-- 		},
-- 	},
-- })

nvimtree.setup({
	hijack_cursor = true,
	sync_root_with_cwd = true,
	view = {
		adaptive_size = false,
		-- mappings = {
		-- 	list = {
		-- 		{ key = { "<2-RightMouse>", "<C-]>" }, action = "" }, -- cd
		-- 		{ key = "<C-v>", action = "" }, -- vsplit
		-- 		{ key = "<C-x>", action = "" }, -- split
		-- 		{ key = "<C-t>", action = "" }, -- tabnew
		-- 		{ key = "<BS>", action = "" }, -- close_node
		-- 		{ key = "<Tab>", action = "" }, -- preview
		-- 		{ key = "D", action = "" }, -- trash
		-- 		{ key = "[e", action = "" }, -- prev_diag_item
		-- 		{ key = "]e", action = "" }, -- next_diag_item
		-- 		{ key = "[c", action = "" }, -- prev_git_item
		-- 		{ key = "]c", action = "" }, -- next_git_item
		-- 		{ key = "-", action = "" }, -- dir_up
		-- 		{ key = "s", action = "" }, -- system_open
		-- 		{ key = "W", action = "" }, -- collapse_all
		-- 		{ key = "g?", action = "" }, -- toggle_help
		--
		-- 		{ key = "d", action = "cd" }, -- remove
		-- 		{ key = "x", action = "remove" }, -- cut
		--
		-- 		{ key = "t", action = "cut" },
		-- 		{ key = "<Space>p", action = "prev_diag_item" },
		-- 		{ key = "<Space>.", action = "next_diag_item" },
		-- 		{ key = "<Space>k", action = "prev_git_item" },
		-- 		{ key = "<Space>j", action = "next_git_item" },
		-- 		{ key = "u", action = "dir_up" },
		-- 		{ key = "'", action = "close_node" },
		-- 		{ key = '"', action = "collapse_all" },
		-- 		{ key = "?", action = "toggle_help" },
		-- 	},
		-- },
		--
		preserve_window_proportions = true,
		-- width = 34,
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
			-- git_placement = "signcolumn",
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
		enable = true,
		show_on_dirs = true,
	},
	filters = {
		custom = {
			"^.git$",
		},
	},
	actions = {
		change_dir = {
			enable = false,
			restrict_above_cwd = true,
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
