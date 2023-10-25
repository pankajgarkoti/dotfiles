local setup, nnp = pcall(require, "no-neck-pain")
if not setup then
	return
end

nnp.setup({
	width = 160,
	buffers = {
		-- scratchPad = {
		-- 	-- set to `false` to
		-- 	-- disable auto-saving
		-- 	enabled = false,
		-- 	-- set to `nil` to default
		-- 	-- to current working directory
		-- 	location = "~/Desktop/notes/life/scratchpads",
		-- },
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
