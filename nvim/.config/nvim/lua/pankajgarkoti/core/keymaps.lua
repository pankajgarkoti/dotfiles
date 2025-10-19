vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function process_single_line(line)
	-- Match standard markdown checkbox patterns: [ ], [x], [-]
	local checkbox_pattern = "%[([%s%-x])%]"
	local checkbox_state = line:match(checkbox_pattern)

	if not checkbox_state then
		-- Check if line already has a bullet point (with possible indentation)
		local indent, bullet, space, content = line:match("^(%s*)([%-%*%+])(%s+)(.*)")

		if indent and bullet then
			-- Preserve existing bullet style and indentation
			return indent .. bullet .. space .. "[ ] " .. content
		else
			-- No existing bullet, add new one
			return "- [ ] " .. line
		end
	end

	-- Define clear state transitions
	local next_state = {
		[" "] = "x", -- [ ] -> [x]
		["x"] = "-", -- [x] -> [-]
		["-"] = " ", -- [-] -> [ ]
	}

	local new_state = next_state[checkbox_state]
	if new_state then
		return line:gsub(checkbox_pattern, "[" .. new_state .. "]", 1)
	end

	return line
end

local function calculate_new_cursor_position(old_line, new_line, old_cursor_col)
	local checkbox_pattern = "%[([%s%-x])%]"
	local old_checkbox_pos = old_line:find(checkbox_pattern)
	local new_checkbox_pos = new_line:find(checkbox_pattern)

	-- If no checkbox in old line, we added "- [ ] " at the beginning
	if not old_checkbox_pos and new_checkbox_pos then
		local added_prefix = new_line:match("^(.-)%[")
		return old_cursor_col + #added_prefix + 3 -- +3 for "[ ]"
	end

	-- If cursor was before the checkbox, no adjustment needed
	if old_checkbox_pos and old_cursor_col < old_checkbox_pos then
		return old_cursor_col
	end

	-- If cursor was at or after checkbox, check if line length changed
	local length_diff = #new_line - #old_line
	return math.max(0, old_cursor_col + length_diff)
end

local function toggle_markdown_task()
	-- Check if we're in visual mode for multi-line support
	local mode = vim.fn.mode()
	local start_line, end_line

	if mode == 'V' or mode == 'v' or mode == '\22' then -- Visual modes
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		start_line = start_pos[2]
		end_line = end_pos[2]
	else
		-- Single line mode
		start_line = vim.api.nvim_win_get_cursor(0)[1]
		end_line = start_line
	end

	-- Process each line in the range
	for line_num = start_line, end_line do
		local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
		local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

		-- Only get cursor position for the current line
		local preserve_cursor = (line_num == vim.api.nvim_win_get_cursor(0)[1])

		local new_line = process_single_line(line)

		-- Calculate new cursor position if this is the current line
		if preserve_cursor and new_line ~= line then
			cursor_col = calculate_new_cursor_position(line, new_line, cursor_col)
		end

		-- Update the line
		vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })

		-- Restore cursor position for current line
		if preserve_cursor then
			vim.api.nvim_win_set_cursor(0, { line_num, cursor_col })
		end
	end

	-- Exit visual mode if we were in it
	if mode == 'V' or mode == 'v' or mode == '\22' then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
	end
end

-- Function to toggle conceal level
local function toggle_conceal()
	if vim.bo.filetype == "markdown" then
		local ok, render_markdown = pcall(require, "render-markdown")
		if ok then
			render_markdown.toggle()
			return
		end
	end

	-- Fallback for other filetypes
	if vim.wo.conceallevel == 0 then
		vim.wo.conceallevel = 2
		vim.notify("Conceal enabled", vim.log.levels.INFO)
	else
		vim.wo.conceallevel = 0
		vim.notify("Conceal disabled (raw text)", vim.log.levels.INFO)
	end
end

-- Set the keymaps for timestamped lines

vim.g.mapleader = " "
KEYMAPS = {
	{
		"i",
		"jk",
		"<ESC>",
		{ noremap = true, silent = true, desc = "Exit insert mode" },
	},
	{
		"n",
		"<leader>nh",
		":nohl<CR>",
		{ noremap = true, silent = true, desc = "Clear search highlights" },
	},

	-- Increment or decrement numbers
	{
		"n",
		"<leader>+",
		"<C-a>",
		{ noremap = true, silent = true, desc = "Increment number" },
	},
	{
		"n",
		"<leader>-",
		"<C-x>",
		{ noremap = true, silent = true, desc = "Decrement number" },
	},

	-- Window management keymaps
	{
		"n",
		"<leader>sv",
		"<C-w>v",
		{ noremap = true, silent = true, desc = "Split window vertically" },
	},
	{
		"n",
		"<leader>sh",
		"<C-w>s",
		{ noremap = true, silent = true, desc = "Split window horizontally" },
	},
	{
		"n",
		"<leader>se",
		"<C-w>=",
		{ noremap = true, silent = true, desc = "Equalize window dimensions" },
	},
	{
		"n",
		"<leader>sx",
		":close<CR>",
		{ noremap = true, silent = true, desc = "Close current window" },
	},

	-- Nvim Tree (file explorer)
	{
		"n",
		"<leader>e",
		":NvimTreeToggle<CR>",
		{ noremap = true, silent = true, desc = "Toggle file explorer" },
	},

	-- Telescope keymaps
	-- {
	--     "n",
	--     "<leader>ff",
	--     "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git', '--glob', '.*'}})<cr>",
	--     { noremap = true, silent = true, desc = "Find files" },
	-- },
	-- {
	--     "n",
	--     "<leader>fs",
	--     "<cmd>lua require'telescope.builtin'.live_grep({ additional_args = {'--hidden', '--no-ignore', '-g', '!.git', '--glob', '.*'}})<cr>",
	--     { noremap = true, silent = true, desc = "Live grep" },
	-- },
	{
		"n",
		"<leader>ff",
		"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '--no-ignore'}})<cr>",
		{ noremap = true, silent = true, desc = "Find files" },
	},
	{
		"n",
		"<leader>fs",
		"<cmd>lua require'telescope.builtin'.live_grep({ find_command = {'rg', '--hidden', '--no-ignore'}})<cr>",
		{ noremap = true, silent = true, desc = "Live grep" },
	},
	{
		"n",
		"<leader>fc",
		"<cmd>Telescope grep_string no_ignore=true<cr>",
		{ noremap = true, silent = true, desc = "Grep string under cursor" },
	},
	{
		"n",
		"<leader>fb",
		"<cmd>Telescope buffers no_ignore=true<cr>",
		{ noremap = true, silent = true, desc = "List open buffers" },
	},
	{
		"n",
		"<leader>fh",
		"<cmd>Telescope help_tags<cr>",
		{ noremap = true, silent = true, desc = "List help tags" },
	},
	{
		"n",
		"<leader>fj",
		"<cmd>Telescope treesitter<cr>",
		{ noremap = true, silent = true, desc = "Treesitter symbols" },
	},
	{
		"n",
		"<leader>fk",
		"<cmd>Telescope keymaps<cr>",
		{ noremap = true, silent = true, desc = "Defined keymaps" },
	},

	-- Telescope git keymaps
	{
		"n",
		"<leader>gc",
		"<cmd>Telescope git_commits<cr>",
		{ noremap = true, silent = true, desc = "List all git commits" },
	},
	{
		"n",
		"<leader>gfc",
		"<cmd>Telescope git_bcommits<cr>",
		{ noremap = true, silent = true, desc = "Git commits for current file" },
	},
	{
		"n",
		"<leader>gb",
		"<cmd>Telescope git_branches<cr>",
		{ noremap = true, silent = true, desc = "List git branches" },
	},
	{
		"n",
		"<leader>gs",
		"<cmd>Telescope git_status<cr>",
		{ noremap = true, silent = true, desc = "Git status" },
	},

	-- Restart LSP server
	{
		"n",
		"<leader>rs",
		":LspRestart<CR>",
		{ noremap = true, silent = true, desc = "Restart LSP server" },
	},

	-- Harpoon keymaps
	{
		"n",
		"<leader>hm",
		":lua require('harpoon.mark').add_file()<CR>",
		{ noremap = true, silent = true, desc = "Add file to Harpoon" },
	},
	{
		"n",
		"<leader>hn",
		":lua require('harpoon.ui').nav_next()<CR>",
		{ noremap = true, silent = true, desc = "Next Harpoon mark" },
	},
	{
		"n",
		"<leader>hp",
		":lua require('harpoon.ui').nav_prev()<CR>",
		{ noremap = true, silent = true, desc = "Previous Harpoon mark" },
	},
	{
		"n",
		"<leader>hh",
		":lua require('harpoon.ui').toggle_quick_menu()<CR>",
		{ noremap = true, silent = true, desc = "Toggle Harpoon quick menu" },
	},
	{
		"n",
		"<leader>1",
		":lua require('harpoon.ui').nav_file(1)<CR>",
		{ noremap = true, silent = true, desc = "Harpoon file 1" },
	},
	{
		"n",
		"<leader>2",
		":lua require('harpoon.ui').nav_file(2)<CR>",
		{ noremap = true, silent = true, desc = "Harpoon file 2" },
	},
	{
		"n",
		"<leader>3",
		":lua require('harpoon.ui').nav_file(3)<CR>",
		{ noremap = true, silent = true, desc = "Harpoon file 3" },
	},
	{
		"n",
		"<leader>4",
		":lua require('harpoon.ui').nav_file(4)<CR>",
		{ noremap = true, silent = true, desc = "Harpoon file 4" },
	},
	{
		"n",
		"<leader>5",
		":lua require('harpoon.ui').nav_file(5)<CR>",
		{ noremap = true, silent = true, desc = "Harpoon file 5" },
	},

	-- Datetime related keymaps in insert mode
	{
		"i",
		"<C-d>",
		"<C-R>=strftime('%c')<CR>",
		{ noremap = false, silent = true, desc = "Insert current datetime" },
	},
	{
		"i",
		"<C-d><C-f>",
		"<C-R>=strftime('%c')<CR>",
		{ noremap = true, silent = true, desc = "Insert full datetime" },
	},
	{
		"i",
		"<C-d><C-d>",
		"<C-R>=strftime('%Y-%m-%d')<CR>",
		{ noremap = true, silent = true, desc = "Insert current date" },
	},
	{
		"i",
		"<C-d><C-t>",
		"<C-R>=strftime('%H:%M:%S')<CR>",
		{ noremap = true, silent = true, desc = "Insert current time" },
	},
	{
		"i",
		"<C-d><C-s>",
		"<C-R>=strftime('%m/%d/%y')<CR>",
		{ noremap = true, silent = true, desc = "Insert short date" },
	},
	{
		"i",
		"<C-d><C-w>",
		"<C-R>=strftime('%A %Y-%m-%d')<CR>",
		{ noremap = true, silent = true, desc = "Insert current weekday and date" },
	},
	{
		"n",
		"<leader><CR>",
		toggle_markdown_task,
		{ noremap = true, silent = true, desc = "Toggle between markdown task states" },
	},
	{
		"n",
		"<leader>lr",
		toggle_conceal,
		{ noremap = true, silent = true, desc = "Toggle conceal (raw/rendered)" },
	},
	{
		"n",
		"<C-a>",
		"<cmd>CodeCompanionActions<cr>",
		{ noremap = true, silent = true, desc = "Show CodeCompanion Actions Menu" },
	},
	{
		"v",
		"<C-a>",
		"<cmd>CodeCompanionActions<cr>",
		{ noremap = true, silent = true, desc = "Show CodeCompanion Actions Menu" },
	},
}


_G.map_keys = function(mappings, user_opts)
	local opts = {
		mode = "n",        -- Default to normal mode
		prefix = "<leader>", -- No prefix by default
		noremap = true,
		silent = true,
	}

	-- Merge user options with the default options
	-- local opts = vim.tbl_extend('force', default_opts, user_opts or {})
	if user_opts then
		for k, v in pairs(user_opts or {}) do
			opts[k] = v
		end
	end

	-- Recursive function to traverse and set mappings
	local function set_keymaps(prefix, map)
		for key, value in pairs(map) do
			local combo = prefix .. key
			if type(value) == "table" and not vim.tbl_islist(value) then
				set_keymaps(combo, value) -- combine prefix and key for nested maps
			else
				local command = value[1]
				local description = value[2] or ""
				if not command then
					assert(false, "No valid command specified for key map " .. combo .. " got " .. vim.inspect(value))
				end
				vim.api.nvim_set_keymap(
					opts.mode,
					combo,
					command,
					{ noremap = opts.noremap, silent = opts.silent, desc = description }
				)
			end
		end
	end

	set_keymaps(opts.prefix, mappings)
end

local init_keymaps = function()
	for _, keymap in pairs(KEYMAPS) do
		local mode = keymap[1]
		local key = keymap[2]
		local cmd = keymap[3]
		local opts = keymap[4]
		vim.keymap.set(mode, key, cmd, opts)
	end
	return true
end

local success, _ = pcall(init_keymaps)

if not success then
	print("Failed to initialize keymaps.")
end
