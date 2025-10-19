return {
	'echasnovski/mini.nvim',
	config = function()
		vim.o.laststatus = 3
		require("mini.starter").setup()
		require("mini.align").setup()
		require("mini.diff").setup()
		require("mini.git").setup()
		require('mini.bufremove').setup()

		-- Delete buffers
		vim.keymap.set('n', '<leader>q', function()
			require('mini.bufremove').delete(0, false)
		end)

		require("mini.indentscope").setup(
			{
				draw = {
					delay = 0,
					animation = require('mini.indentscope').gen_animation.none(),
					priority = 2,
				},
				mappings = {
					object_scope = 'ii',
					object_scope_with_border = 'ai',
					goto_top = '[i',
					goto_bottom = ']i',
				},
				options = {
					border = 'both',
					indent_at_cursor = false,
					try_as_border = false,
				},
				symbol = "│",
			})
	end
}
