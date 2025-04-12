vim.g.mapleader = " "

-- Logging and notetaking keymaps
local function mark_task_done()
	local line = vim.api.nvim_get_current_line()
	local square_match = line:match("%[%s*[%s%-x]%s*%]")
	local markdown_state_map = {
		["[ ]"] = "[x]",
		["[x]"] = "[-]",
		["[-]"] = "[ ]"
	}

	local function get_new_line(content)
		return string.gsub(line, "%[%s*[%s%-x]%s*%]", content, 1)
	end

	if not square_match then
		local new_line = "- [ ] " .. line
		vim.api.nvim_set_current_line(new_line)
		return
	end

	for state, new_state in pairs(markdown_state_map) do
		if square_match == state then
			local new_line = get_new_line(new_state)
			vim.api.nvim_set_current_line(new_line)
			return
		end
	end
end


-- Helper function to insert timestamped line
local function insert_timestamped_line(same_line)
	local current_line = vim.fn.line('.')
	local indent = vim.fn.indent(current_line)
	local timestamp = os.date('%H:%M:%S')
	local current_content = vim.api.nvim_get_current_line()

	if same_line then
		local new_content = current_content .. ' - ' .. '[' .. timestamp .. '] '
		vim.api.nvim_set_current_line(new_content)
		vim.api.nvim_win_set_cursor(0, { current_line, #new_content })
	else
		local new_line = string.rep(' ', indent) .. ' - ' .. '[' .. timestamp .. '] '
		vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { new_line })
		vim.api.nvim_win_set_cursor(0, { current_line + 1, #new_line })
	end

	vim.cmd('startinsert!')
end

-- Set the keymaps for timestamped lines

KEYMAPS = {
	{ "i", "jk",           "<ESC>",                                                                                                               { noremap = true, silent = true, desc = "Exit insert mode" } },
	{ "n", "<leader>nh",   ":nohl<CR>",                                                                                                           { noremap = true, silent = true, desc = "Clear search highlights" } },

	-- Increment or decrement numbers
	{ "n", "<leader>+",    "<C-a>",                                                                                                               { noremap = true, silent = true, desc = "Increment number" } },
	{ "n", "<leader>-",    "<C-x>",                                                                                                               { noremap = true, silent = true, desc = "Decrement number" } },

	-- Window management keymaps
	{ "n", "<leader>sv",   "<C-w>v",                                                                                                              { noremap = true, silent = true, desc = "Split window vertically" } },
	{ "n", "<leader>sh",   "<C-w>s",                                                                                                              { noremap = true, silent = true, desc = "Split window horizontally" } },
	{ "n", "<leader>se",   "<C-w>=",                                                                                                              { noremap = true, silent = true, desc = "Equalize window dimensions" } },
	{ "n", "<leader>sx",   ":close<CR>",                                                                                                          { noremap = true, silent = true, desc = "Close current window" } },

	-- Tab navigation keymaps
	{ "n", "<leader>to",   "<Cmd>tabnew<CR>",                                                                                                     { noremap = true, silent = true, desc = "Open new tab" } },
	{ "n", "<leader>tx",   "<Cmd>bdelete<CR>",                                                                                                    { noremap = true, silent = true, desc = "Close buffer" } },
	{ "n", "<leader>tn",   "<Cmd>bnext<CR>",                                                                                                      { noremap = true, silent = true, desc = "Next buffer" } },
	{ "n", "<leader>tp",   "<Cmd>bprevious<CR>",                                                                                                  { noremap = true, silent = true, desc = "Previous buffer" } },

	-- Block selection keymaps
	{ "n", "<leader>bss",  "md",                                                                                                                  { noremap = true, silent = true, desc = "Select block start" } },
	{ "n", "<leader>bse",  "y'd",                                                                                                                 { noremap = true, silent = true, desc = "Select block end" } },

	-- Plugin keymaps
	{ "n", "<leader>sm",   ":MaximizerToggle<CR>",                                                                                                { noremap = true, silent = true, desc = "Toggle Maximizer" } },

	-- LSP
	{ "n", "<leader>gd",   "<cmd>lua vim.lsp.buf.definition()<CR>",                                                                               { noremap = true, silent = true, desc = "Go to definition" } },

	-- Nvim Tree (file explorer)
	{ "n", "<leader>e",    ":NvimTreeToggle<CR>",                                                                                                 { noremap = true, silent = true, desc = "Toggle file explorer" } },

	-- Telescope keymaps
	{ "n", "<leader>ff",   "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", { noremap = true, silent = true, desc = "Find files" } },
	{ "n", "<leader>fs",   "<cmd>lua require'telescope.builtin'.live_grep({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",  { noremap = true, silent = true, desc = "Live grep" } },
	{ "n", "<leader>fc",   "<cmd>Telescope grep_string no_ignore=true<cr>",                                                                       { noremap = true, silent = true, desc = "Grep string under cursor" } },
	{ "n", "<leader>fb",   "<cmd>Telescope buffers no_ignore=true<cr>",                                                                           { noremap = true, silent = true, desc = "List open buffers" } },
	{ "n", "<leader>fh",   "<cmd>Telescope help_tags<cr>",                                                                                        { noremap = true, silent = true, desc = "List help tags" } },
	{ "n", "<leader>fj",   "<cmd>Telescope treesitter<cr>",                                                                                       { noremap = true, silent = true, desc = "Treesitter symbols" } },

	-- Telescope git keymaps
	{ "n", "<leader>gc",   "<cmd>Telescope git_commits<cr>",                                                                                      { noremap = true, silent = true, desc = "List all git commits" } },
	{ "n", "<leader>gfc",  "<cmd>Telescope git_bcommits<cr>",                                                                                     { noremap = true, silent = true, desc = "Git commits for current file" } },
	{ "n", "<leader>gb",   "<cmd>Telescope git_branches<cr>",                                                                                     { noremap = true, silent = true, desc = "List git branches" } },
	{ "n", "<leader>gs",   "<cmd>Telescope git_status<cr>",                                                                                       { noremap = true, silent = true, desc = "Git status" } },

	-- Restart LSP server
	{ "n", "<leader>rs",   ":LspRestart<CR>",                                                                                                     { noremap = true, silent = true, desc = "Restart LSP server" } },

	-- Harpoon keymaps
	{ "n", "<leader>hm",   ":lua require('harpoon.mark').add_file()<CR>",                                                                         { noremap = true, silent = true, desc = "Add file to Harpoon" } },
	{ "n", "<leader>hn",   ":lua require('harpoon.ui').nav_next()<CR>",                                                                           { noremap = true, silent = true, desc = "Next Harpoon mark" } },
	{ "n", "<leader>hp",   ":lua require('harpoon.ui').nav_prev()<CR>",                                                                           { noremap = true, silent = true, desc = "Previous Harpoon mark" } },
	{ "n", "<leader>hh",   ":lua require('harpoon.ui').toggle_quick_menu()<CR>",                                                                  { noremap = true, silent = true, desc = "Toggle Harpoon quick menu" } },
	{ "n", "<leader>1",    ":lua require('harpoon.ui').nav_file(1)<CR>",                                                                          { noremap = true, silent = true, desc = "Harpoon file 1" } },
	{ "n", "<leader>2",    ":lua require('harpoon.ui').nav_file(2)<CR>",                                                                          { noremap = true, silent = true, desc = "Harpoon file 2" } },
	{ "n", "<leader>3",    ":lua require('harpoon.ui').nav_file(3)<CR>",                                                                          { noremap = true, silent = true, desc = "Harpoon file 3" } },
	{ "n", "<leader>4",    ":lua require('harpoon.ui').nav_file(4)<CR>",                                                                          { noremap = true, silent = true, desc = "Harpoon file 4" } },
	{ "n", "<leader>5",    ":lua require('harpoon.ui').nav_file(5)<CR>",                                                                          { noremap = true, silent = true, desc = "Harpoon file 5" } },

	-- Datetime related keymaps in insert mode
	{ 'i', '<C-d>',        "<C-R>=strftime('%c')<CR>",                                                                                            { noremap = false, silent = true, desc = "Insert current datetime" } },
	{ 'i', '<C-d><C-f>',   "<C-R>=strftime('%c')<CR>",                                                                                            { noremap = true, silent = true, desc = "Insert full datetime" } },
	{ 'i', '<C-d><C-d>',   "<C-R>=strftime('%Y-%m-%d')<CR>",                                                                                      { noremap = true, silent = true, desc = "Insert current date" } },
	{ 'i', '<C-d><C-t>',   "<C-R>=strftime('%H:%M:%S')<CR>",                                                                                      { noremap = true, silent = true, desc = "Insert current time" } },
	{ 'i', '<C-d><C-s>',   "<C-R>=strftime('%m/%d/%y')<CR>",                                                                                      { noremap = true, silent = true, desc = "Insert short date" } },
	{ 'i', '<C-d><C-w>',   "<C-R>=strftime('%A %Y-%m-%d')<CR>",                                                                                   { noremap = true, silent = true, desc = "Insert current weekday and date" } },
	{ 'n', '<leader><CR>', '<Plug>(neorg.qol.todo-items.todo.task-cycle)',                                                                        { noremap = true, silent = true, desc = "Mark Neorg todo list item as done" } },
	{ 'n', '<leader>lc',   mark_task_done,                                                                                                        { noremap = true, silent = true, desc = "Mark Markdown todo list item as done" } },
	{ 'n', '<leader>ln',   function() insert_timestamped_line(false) end,                                                                         { noremap = true, silent = true, desc = "Insert timestamped line below" } },
	{ 'n', '<leader>ll',   function() insert_timestamped_line(true) end,                                                                          { noremap = true, silent = true, desc = "Insert timestamp at end of current line" } },
	{ "n", "<C-a>",        "<cmd>CodeCompanionActions<cr>",                                                                                       { noremap = true, silent = true, desc = "Show CodeCompanion Actions Menu" } },
	{ "v", "<C-a>",        "<cmd>CodeCompanionActions<cr>",                                                                                       { noremap = true, silent = true, desc = "Show CodeCompanion Actions Menu" } },
	{ "n", "<leader>aa",   "<cmd>CodeCompanionToggle<cr>",                                                                                        { noremap = true, silent = true, desc = "Toggle CodeCompanion" } },
	{ "v", "<leader>aa",   "<cmd>CodeCompanionToggle<cr>",                                                                                        { noremap = true, silent = true, desc = "Toggle CodeCompanion" } },
	{ "v", "ga",           "<cmd>CodeCompanionAdd<cr>",                                                                                           { noremap = true, silent = true, desc = "Add to CodeCompanion Buffer" } },
}


--[[
Set up key mappings based on a structured table with optional overrides.

Parameters:
	mappings (table): A table where each key represents a key combination
										and the value is another table containing the command
										and description. Nested tables allow hierarchical key maps.
	user_opts (table): A table optionally containing custom options such as:
		- mode (string): The mode in which to set mappings, default is 'n' for normal mode.
		- prefix (string): A string to prefix all key mappings, default is ''.
		- noremap (boolean): Whether to use non-recursive mapping, default is true.
		- silent (boolean): Whether to execute mappings silently, default is true.

Usage:
	map_keys({
		d = {
			name = '+debug',
			u = { '<Cmd>lua require"dapui".toggle()<CR>', 'ui toggle' },
			e = { '<Cmd>lua require"dapui".eval()<CR>', 'eval' },
		},
	}, {
		prefix = '<leader>',
		mode = 'n',  -- Normal mode
	})
]] --
_G.map_keys = function(mappings, user_opts)
	local opts = {
		mode = 'n',        -- Default to normal mode
		prefix = '<leader>', -- No prefix by default
		noremap = true,
		silent = true,
	}

	-- Merge user options with the default options
	-- local opts = vim.tbl_extend('force', default_opts, user_opts or {})
	-- Use vim.tbl_deep_extend instead of vim.tbl_extend to merge nested tables
	if user_opts then
		for k, v in pairs(user_opts or {}) do
			opts[k] = v
		end
	end

	-- Recursive function to traverse and set mappings
	local function set_keymaps(prefix, map)
		for key, value in pairs(map) do
			local combo = prefix .. key
			if type(value) == 'table' and not vim.tbl_islist(value) then
				set_keymaps(combo, value) -- combine prefix and key for nested maps
			else
				local command = value[1]
				local description = value[2] or ""
				if not command then
					assert(false, 'No valid command specified for key map ' .. combo .. ' got ' .. vim.inspect(value))
				end
				vim.api.nvim_set_keymap(opts.mode, combo, command,
					{ noremap = opts.noremap, silent = opts.silent, desc = description })
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
