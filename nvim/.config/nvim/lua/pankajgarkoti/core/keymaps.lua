vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local keymap = vim.keymap

-- general keymaps
keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>")
-- keymap.set("n", "x", "_x")

-- increment or decrement numbers
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- window splits
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")

-- tab navigation
keymap.set("n", "<leader>to", "<Cmd>tabnew<CR>")
keymap.set("n", "<leader>tx", "<Cmd>bdelete<CR>")
keymap.set("n", "<leader>tn", "<Cmd>bnext<CR>")
keymap.set("n", "<leader>tp", "<Cmd>bprevious<CR>")

-- select block
keymap.set("n", "<leader>bss", "md")
keymap.set("n", "<leader>bse", "y'd")

-- plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- CoC keymaps
keymap.set("n", "<leader>gd", ":MaximizerToggle<CR>")
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim tree (file explorer)
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")  -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")   -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")     -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")   -- list available help tags

-- telescope git
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")   -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")  -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")    -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- harpoon
keymap.set("n", "<leader>hm", ":lua require('harpoon.mark').add_file()<cr>")        -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hn", ":lua require('harpoon.ui').nav_next()<cr>")          -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()<cr>")          -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<cr>") -- mapping to restart lsp if necessary
keymap.set("n", "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>")
keymap.set("n", "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>")
keymap.set("n", "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>")
keymap.set("n", "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>")
keymap.set("n", "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>")


-- datetime related mappings in insert mode
keymap.set('i', '<C-d>', "<C-R>=strftime('%c')<CR>", opts)
vim.keymap.set('i', '<C-d><C-f>', "<C-R>=strftime('%c')<CR>", opts)
vim.keymap.set('i', '<C-d><C-d>', "<C-R>=strftime('%Y-%m-%d')<CR>", opts)
vim.keymap.set('i', '<C-d><C-t>', "<C-R>=strftime('%H:%M:%S')<CR>", opts)
vim.keymap.set('i', '<C-d><C-s>', "<C-R>=strftime('%m/%d/%y')<CR>", opts)
vim.keymap.set('i', '<C-d><C-w>', "<C-R>=strftime('%A')<CR>", opts)


-- logging and notetaking keymaps
-- mark the task as done, if the checkboxes are of the form [x] or [X], change them with code
-- if they are of form ( ) or (x) call the neorg.qol.todo-items.todo.task-cycle function

local function mark_task_done()
	local line = vim.api.nvim_get_current_line()
	local square_match = line:match("%[%s*%]")
	local current_line = vim.api.nvim_get_current_line()

	local markdown_state_map = {
		[' '] = "x",
		['x'] = "-",
		['-'] = " ",
	}

	if not square_match then
		local new_line = "- [ ] " .. current_line
		vim.api.nvim_set_current_line(new_line)
		return
	end

	local boxed = function(char)
		return "[" .. char .. "]"
	end

	for state, new_state in pairs(markdown_state_map) do
		if square_match and square_match == state then
			local new_line = current_line:gsub(boxed(square_match), boxed(new_state))
			vim.api.nvim_set_current_line(new_line)
		end
	end
end

vim.keymap.set('n', '<leader><CR>', '<Plug>(neorg.qol.todo-items.todo.task-cycle)',
	{ noremap = true, silent = true, desc = "Mark Neorg todo list item as done" }
)
vim.keymap.set('n', '<leader>lc', mark_task_done,
	{ noremap = true, silent = true, desc = "Mark Markdown todo list item as done" }
)

-- Function to insert timestamped line below current line.
-- same_line: boolean, if true, inserts the timestamp at the end of the current line, otherwise inserts it on the next line
local function insert_timestamped_line(same_line)
	local current_line = vim.fn.line('.')
	local indent = vim.fn.indent(current_line)
	local timestamp = os.date('%H:%M:%S')
	local current_content = vim.api.nvim_get_current_line()

	if same_line then
		-- Insert at the end of the current line
		local new_content = current_content .. ' - ' .. '[' .. timestamp .. '] '
		vim.api.nvim_set_current_line(new_content)
		vim.api.nvim_win_set_cursor(0, { current_line, #new_content })
	else
		-- Insert on the next line
		local new_line = string.rep(' ', indent) .. ' - ' .. '[' .. timestamp .. '] '
		vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { new_line })
		vim.api.nvim_win_set_cursor(0, { current_line + 1, #new_line })
	end

	vim.cmd('startinsert!')
end

-- Set the keymaps
vim.keymap.set('n', '<leader>ln', function() insert_timestamped_line(false) end,
	{ noremap = true, silent = true, desc = "Insert timestamped line below" }
)
vim.keymap.set('n', '<leader>ll', function() insert_timestamped_line(true) end,
	{ noremap = true, silent = true, desc = "Insert timestamp at end of current line" }
)
