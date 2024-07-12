local setup, noice = pcall(require, "noice")
if not setup then
	return
end

noice.setup({
	lsp = {
		progress = {
			enabled = false,
			format = "lsp_progress",
			format_done = "lsp_progress_done",
			throttle = 1000 / 30,
			view = "mini",
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = false,      -- use a classic bottom cmdline for search
		command_palette = true,     -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_renamv = false,         -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true,      -- add a border to hover docs and signature help
	},
	messages = {
		enabled = true,            -- enables the Noice messages UI
		view = "notify",           -- default view for messages
		view_error = "notify",     -- view for errors
		view_warn = "notify",      -- view for warnings
		view_history = "messages", -- view for :messages
		view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
	},
})
