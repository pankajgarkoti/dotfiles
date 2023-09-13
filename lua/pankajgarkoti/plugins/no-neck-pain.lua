local setup, nnp = pcall(require, "telescope")
if not setup then
	return
end

nnp.setup({
	buffers = {
		scratchPad = {
			-- set to `false` to
			-- disable auto-saving
			enabled = true,
			-- set to `nil` to default
			-- to current working directory
			location = "~/Desktop/notes/life/scratchpads",
		},
		bo = {
			filetype = "md",
		},
		wo = {
			backgroundColor = "tokyonight-moon",
			fillchars = "eob: ",
		},
	},
})
