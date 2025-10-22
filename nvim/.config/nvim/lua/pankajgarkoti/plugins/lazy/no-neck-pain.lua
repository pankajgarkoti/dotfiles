return {
	"shortcuts/no-neck-pain.nvim",
	config = function()
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
			mappings = {
				enabled = true,
				toggle = "<Leader>nn",
				widthUp = "<Leader>n=",
				widthDown = "<Leader>n-",
			},
		})

		local map = vim.keymap.set

		-- Key mappings
		map("n", "<Leader>nn", ":NoNeckPain<CR>")
	end,
}
