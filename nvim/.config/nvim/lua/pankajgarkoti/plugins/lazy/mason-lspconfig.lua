return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not mason_lspconfig_status then
			print("mason_lspconfig not installed")
			return
		end

		mason_lspconfig.setup({
			automatic_enable = {},
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				-- "pyright",
				"basedpyright",
				"pyright",
				"remark_ls",
				"marksman"
			},
			automatic_installation = true,
		})
	end
}

