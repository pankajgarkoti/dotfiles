return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				swift = { "swiftformat" },
			},
			format_on_save = function(bufnr)
				if bufnr == nil then
					return
				end

				local no_autoformat_filetypes = {
					"markdown",
					"norg",
					"org",
					"txt",
					"vimwiki",
					"wiki",
					"js",
					"javascript",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
					"html",
					"css",
					"scss",
					"less",
				}

				local is_in_table = function(table, value)
					for _, v in ipairs(table) do
						if v == value then
							return true
						end
					end
					return false
				end

				if is_in_table(no_autoformat_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				return { timeout_ms = 500, lsp_fallback = true }
			end,
			log_level = vim.log.levels.ERROR,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
