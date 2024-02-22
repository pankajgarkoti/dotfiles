vim.g.mapleader = " "

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
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- harpoon
keymap.set("n", "<leader>hm", ":lua require('harpoon.mark').add_file()<cr>") -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hn", ":lua require('harpoon.ui').nav_next()<cr>") -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()<cr>") -- mapping to restart lsp if necessary
keymap.set("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<cr>") -- mapping to restart lsp if necessary
keymap.set("n", "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>")
keymap.set("n", "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>")
keymap.set("n", "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>")
keymap.set("n", "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>")
keymap.set("n", "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>")

-- toggle terminal
keymap.set("n", "<leader>tt", ":ToggleTerm size=40 direction=float<CR>")
