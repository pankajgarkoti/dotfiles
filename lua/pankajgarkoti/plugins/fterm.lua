local fterm = require("FTerm")
local map = vim.keymap.set

fterm.setup({
	dimensions = {
		height = 0.84,
		width = 0.7,
	},
})

map("n", "<C-g>", fterm.toggle)
map("t", "<C-g>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<CR>")
