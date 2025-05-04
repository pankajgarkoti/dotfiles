-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		formatting.prettier,
		formatting.black,
		-- formatting.stylua,
		-- diagnostics.swiftlint,
		require("none-ls.diagnostics.eslint_d").with({
			condition = function(utils)
				return utils.root_has_file(".eslintrc.js")
			end,
		}),
	},

	vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {}),

	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			local ignore = {}

			local function should_ignore(filetype)
				for _, ft in ipairs(ignore) do
					if ft == filetype then
						return true
					end
				end
			end

			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if should_ignore(vim.bo.filetype) then
						return
					end
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
