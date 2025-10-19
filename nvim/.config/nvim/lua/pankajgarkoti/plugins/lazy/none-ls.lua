return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		require("pankajgarkoti.plugins.lsp.null-ls")
	end
}

