local setup, yode = pcall(require, "telescope")
if not setup then
	return
end

yode.setup({})

-- Enable line numbers
local map = vim.keymap.set

vim.cmd("set number")

-- Key mappings
map("n", "<Leader>Yc", ":YodeCreateSeditorFloating<CR>")
map("n", "<Leader>Yr", ":YodeCreateSeditorReplace<CR>")
map("n", "<Leader>bd", ":YodeBufferDelete<CR>")
map("n", "<Leader>bd", "<Esc>:YodeBufferDelete<CR>")

map("v", "<Leader>Yc", ":YodeCreateSeditorFloating<CR>")
map("v", "<Leader>Yr", ":YodeCreateSeditorReplace<CR>")
map("v", "<Leader>bd", ":YodeBufferDelete<CR>")
map("v", "<Leader>bd", "<Esc>:YodeBufferDelete<CR>")

map("x", "<Leader>Yc", ":YodeCreateSeditorFloating<CR>")
map("x", "<Leader>Yr", ":YodeCreateSeditorReplace<CR>")
map("x", "<Leader>bd", ":YodeBufferDelete<CR>")
map("x", "<Leader>bd", "<Esc>:YodeBufferDelete<CR>")

map("i", "<C-W>r", ":YodeLayoutShiftWinDown<CR>")
map("i", "<C-W>R", ":YodeLayoutShiftWinUp<CR>")
map("i", "<C-W>J", ":YodeLayoutShiftWinBottom<CR>")
map("i", "<C-W>K", ":YodeLayoutShiftWinTop<CR>")

-- Set showtabline to 2
vim.opt.showtabline = 2
