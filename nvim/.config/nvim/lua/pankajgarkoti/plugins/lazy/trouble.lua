return {
	"folke/trouble.nvim",
	opts = {
		auto_close = false,             -- auto close when there are no items
		auto_open = true,               -- auto open when there are items
		auto_preview = true,            -- automatically open preview when on an item
		auto_refresh = true,            -- auto refresh when open
		auto_jump = false,              -- auto jump to the item when there's only one
		focus = true,                   -- Focus the window when opened
		restore = false,                -- restores the last location in the list when opening
		follow = true,                  -- Follow the current item
		indent_guides = true,           -- show indent guides
		max_items = 200,                -- limit number of items that can be displayed per section
		multiline = true,               -- render multi-line messages
		pinned = true,                  -- When pinned, the opened trouble window will be bound to the current buffer
		warn_no_results = true,         -- show a warning when there are no results
		open_no_results = true,         -- open the trouble window when there are no results
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xl",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}

