return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		'nvim-lua/plenary.nvim',
		'jonarrien/telescope-cmdline.nvim',
	},
	config = function()
		local setup, telescope = pcall(require, 'telescope')
		if not setup then
			return
		end

		local actions_setup, actions = pcall(require, 'telescope.actions')
		if not actions_setup then
			return
		end
		local h_pct = 0.4
		local w_pct = 0.6
		local w_limit = 75

		-- configure telescope
		telescope.setup({
			-- configure custom mappings
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,        -- move to prev result
						["<C-j>"] = actions.move_selection_next,            -- move to next result
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- send selected to quickfixlist
						['<C-o>'] = require("telescope.actions.layout").toggle_preview,
					},
					n = {
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						['o'] = require("telescope.actions.layout").toggle_preview,
						['<C-c>'] = actions.close,
					},
				},
				preview = {
					hide_on_startup = false,
					border = "single",
				},
				layout_strategy = 'horizontal',
				layout_config = {
					vertical = {
						mirror = true,
						prompt_position = 'bottom',
						width = function(_, cols, _)
							return math.min(math.floor(w_pct * cols), w_limit)
						end,
						height = function(_, _, rows)
							return math.floor(rows * h_pct)
						end,
					},
				},
			},
		})
		telescope.load_extension("fzf")
	end
}
