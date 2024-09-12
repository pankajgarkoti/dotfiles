local setup, nnp = pcall(require, "no-neck-pain")
if not setup then
	return
end

nnp.setup({
	width = 160,
	buffers = {
		bo = {
			filetype = "md",
		},
		wo = {
			fillchars = "eob: ",
		},
	},
})

-- Enable line numbers
local map = vim.keymap.set

-- Key mappings
map("n", "<Leader>nn", ":NoNeckPain<CR>")
