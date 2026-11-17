return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not mason_lspconfig_status then
			print("mason_lspconfig not installed")
			return
		end

		mason_lspconfig.setup({
			-- Auto-enable every LSP server installed via :Mason, so new
			-- languages work without touching this config. basedpyright is
			-- excluded to avoid duplicate python diagnostics (pyright is used).
			automatic_enable = {
				exclude = { "basedpyright" },
			},
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"emmet_ls",
				"pyright",
				"remark_ls",
				"marksman",
				"lua_ls",
				"bashls",
				"yamlls",
				"jsonls",
				"quick_lint_js",
			},
			automatic_installation = true,
		})
	end
}

