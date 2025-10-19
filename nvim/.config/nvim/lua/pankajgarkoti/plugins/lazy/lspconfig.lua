return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "nvim-treesitter/nvim-treesitter" },

		--* Autocompletion + Snippets *--
		{ "hrsh7th/nvim-cmp" },    -- Completion engine
		{ "hrsh7th/cmp-nvim-lsp" }, -- Show autocompletions
		{ "hrsh7th/cmp-buffer" },  -- source for text in buffer
		{ "hrsh7th/cmp-path" },    -- source for file system paths
		{ "hrsh7th/cmp-cmdline" }, -- Autocompletions for the cmdline
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
		},
		{ "saadparwaiz1/cmp_luasnip" }, -- for autocompletion,
		{ "onsails/lspkind.nvim" },    -- Optional  -> Icons in autocompletion
		{ "dundalek/lazy-lsp.nvim" }   -- Auto install lsp servers
	},
	config = function()
		require("lspconfig/configs")
		require("lspconfig/util")
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true
		}

		local opts = { noremap = true, silent = true }

		vim.o.updatetime = 300

		-- Vim List Line Diagnostics
		vim.diagnostic.config({
			float = false,
			virtual_lines = true,
			update_in_insert = false,
		})

		local on_attach = function(_, bufnr)
			local map = function(mode, lhs, rhs, desc)
				opts.buffer = bufnr
				opts.desc = desc
				vim.keymap.set(mode, lhs, rhs, opts)
			end

			-- LSP-based mappings
			map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
			map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
			map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
			map("n", "gd", vim.lsp.buf.definition, "Go to definition")
			map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
			map("n", "gr", vim.lsp.buf.references, "Show references")
			map("n", "gs", vim.lsp.buf.signature_help, "Show signature help")
			map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
			map("n", "<leader>gw", vim.lsp.buf.document_symbol, "Show document symbols")
			map("n", "<leader>gW", vim.lsp.buf.workspace_symbol, "Show workspace symbols")
			map("n", "<leader>af", vim.lsp.buf.code_action, "Show code actions")
			map("n", "<leader>ar", vim.lsp.buf.rename, "Rename symbol")
			map("n", "<leader>=", vim.lsp.buf.format, "Format document")
			map("n", "<leader>ai", vim.lsp.buf.incoming_calls, "Show incoming calls")
			map("n", "<leader>ao", vim.lsp.buf.outgoing_calls, "Show outgoing calls")
			map("n", "<leader>ld", vim.diagnostic.setloclist, "Show line diagnostics")
		end

		local lazy_lsp = require("lazy-lsp")
		lazy_lsp.setup(
			{
				excluded_servers = {
					"ccls", "zk",
				},
				preferred_servers = {
					markdown = { "marksman" },
					python = { "pyright" },
					typescript = { "ts_ls" },
					typescriptreact = { "ts_ls" },
					css = { "cssls" },
				},
				default_config = {
					flags = {
						debounce_text_changes = 300,
					},
					on_attach = on_attach,
					capabilities = capabilities,
				},
				prefer_local = false,
				-- Override config for specific servers that will passed down to lspconfig setup.
				-- Note that the default_config will be merged with this specific configuration so you don't need to specify everything twice.
				configs = {
					lua_ls = {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					},
				},
			}
		)

		lspconfig["sourcekit"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure html server
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure typescript server
		lspconfig["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescript", "typescriptreact", "javascript", "javascriptreact" },
		})

		-- configure css server
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- configure md server
		lspconfig["marksman"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "markdown" },
		})

		lspconfig["remark_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "markdown" },
			settings = {
				remark = {
					requireConfig = true
				}
			}
		})

		-- configure shell server
		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "zsh", "bash", "sh" },
		})

		-- configure tailwindcss server
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})


		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})


		-- configure emmet language server
		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "python" },
		})

		local capabilities_alt = vim.lsp.protocol.make_client_capabilities()

		capabilities_alt.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true
		}

		lspconfig["yamlls"].setup({
			capabilities = capabilities_alt,
			on_attach = on_attach,
			filetypes = { "yaml", "yml" },
		})

		lspconfig["quick_lint_js"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "javascript", "typescript" },
		})

		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- config for vue-language-server (volar)
		lspconfig["volar"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
			init_options = {
				vue = {
					hybridMode = false,
				},
			}
		})

		-- import nvim-cmp plugin safely
		local cmp_status, cmp = pcall(require, "cmp")
		if not cmp_status then
			return
		end

		-- import luasnip plugin safely
		local luasnip_status, luasnip = pcall(require, "luasnip")
		if not luasnip_status then
			return
		end

		-- import lspkind plugin safely
		local lspkind_status, lspkind = pcall(require, "lspkind")
		if not lspkind_status then
			return
		end

		-- load vs-code like snippets from plugins (e.g. friendly-snippets)
		require("luasnip/loaders/from_vscode").lazy_load()

		vim.opt.completeopt = "menu,menuone,noselect"
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = {
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if luasnip.expandable() then
							luasnip.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
				{ name = "supermaven" }
			}),

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = 50,
					ellipsis_char = "...",
					symbol_map = {
						Codeium = "",
						Supermaven = "",
					},
				}),
			},
		})
	end,
}

