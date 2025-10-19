return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			ignore_filetypes = { TelescopePrompt = true },
			disable_inline_completion = false, -- disables inline completion for use with cmp disable_keymaps = false,
			keymaps = {
				accept_suggestion = "<C-a>",
				clear_suggestion = "<C-x>",
				accept_word = "<C-j>",
			},
		})
	end,
}
