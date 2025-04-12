local setup, nnp = pcall(require, "no-neck-pain")
if not setup then
	return
end

nnp.setup({
	-- The width of the focused window that will be centered. When the terminal width is less than the `width` option, the side buffers won't be created.
	--- @type integer|"textwidth"|"colorcolumn"
	width = 200,
	-- Represents the lowest width value a side buffer should be.
	--- @type integer
	minSideBufferWidth = 10,


	buffers = {
		bo = {
			filetype = "md",
		},
		wo = {
			fillchars = "eob: ",
		},
	},

	--- @type table
	mappings = {
		--- @type boolean
		enabled = true,
		--- @type string
		toggle = "<Leader>nn",
		--- @type string | { mapping: string, value: number }
		widthUp = "<Leader>n=",
		--- @type string | { mapping: string, value: number }
		widthDown = "<Leader>n-",
	},
})

local map = vim.keymap.set

-- Key mappings
map("n", "<Leader>nn", ":NoNeckPain<CR>")
