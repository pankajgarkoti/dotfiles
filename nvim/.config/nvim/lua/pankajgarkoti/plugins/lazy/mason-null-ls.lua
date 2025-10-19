return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvimtools/none-ls.nvim",
		"williamboman/mason.nvim",
	},
	config = function()
		local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
		if not mason_null_ls_status then
			print("mason_null_ls not installed")
			return
		end

		mason_null_ls.setup({
			-- list of formatters & linters for mason to install
			ensure_installed = {
				"prettier",
				"eslint_d",
				"black",
				"stylua",
				"marksman",
				"prettierd",
				"shellcheck",
				"beautysh",
				"shfmt",
			},
			-- auto-install configured formatters & linters (with null-ls)
			automatic_installation = true,
		})
	end
}

