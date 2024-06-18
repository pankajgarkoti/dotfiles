local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

return require("lazy").setup({
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		config = true,
	},
	{ --* so fucking beautiful *--
		"rose-pine/neovim",
		enabled = true,
		lazy = false,
		priority = 1000,
		styles = {
			transparency = true,
		},
		config = function()
			vim.cmd([[colorscheme rose-pine]])
		end,
	},
	"nvim-lua/plenary.nvim",
	"shortcuts/no-neck-pain.nvim",
	"folke/noice.nvim",
	"christoomey/vim-tmux-navigator",
	"tpope/vim-surround",
	"vim-scripts/ReplaceWithRegister",
	"numToStr/Comment.nvim",
	"nvim-tree/nvim-tree.lua",
	"kyazdani42/nvim-web-devicons",
	"nvim-lualine/lualine.nvim",
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = { "│" },
			},
		}
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
	},
	"rafamadriz/friendly-snippets", -- useful snippets
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		dependencies = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("pankajgarkoti.plugins.treesitter")
		end
	},
	"windwp/nvim-autopairs",  -- autoclose parens, brackets, quotes, etc...
	"lewis6991/gitsigns.nvim", -- show line modifications on left hand side
	"tpope/vim-fugitive",     -- vim git plugin
	"marko-cerovac/material.nvim",
	"ThePrimeagen/harpoon",
	"numToStr/FTerm.nvim",
	"APZelos/blamer.nvim",
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	},
	{
		"Exafunction/codeium.vim",
		opts = {
			language_server = "~/codeium_ls_v1.1",
		},
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<C-a>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	},
	"MunifTanjim/nui.nvim",
	"rcarriga/nvim-notify",
	"sindrets/diffview.nvim",
	{
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-tree.lua",      -- (optional) to manage project files
			"stevearc/oil.nvim",            -- (optional) to manage project files
			"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
		},
		config = function()
			require("xcodebuild").setup({})
		end,
	},
	"mfussenegger/nvim-dap",
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		}
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				swift = { "swiftlint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					require("lint").try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ml", function()
				require("lint").try_lint()
			end, { desc = "Lint file" })
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					swift = { "swiftformat" },
				},
				format_on_save = function(bufnr)
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
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "nvim-treesitter/nvim-treesitter" },

			--* Autocompletion + Snippets *--
			{ "hrsh7th/nvim-cmp" },  -- Completion engine
			{ "hrsh7th/cmp-nvim-lsp" }, -- Show autocompletions
			{ "hrsh7th/cmp-buffer" }, -- source for text in buffer
			{ "hrsh7th/cmp-path" },  -- source for file system paths
			{ "hrsh7th/cmp-cmdline" }, -- Autocompletions for the cmdline
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
			},
			{ "saadparwaiz1/cmp_luasnip" }, -- for autocompletion,
			{ "onsails/lspkind.nvim" },  -- Optional  -> Icons in autocompletion
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()
			local opts = { noremap = true, silent = true }

			vim.o.updatetime = 300
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false })
				end
			})

			vim.diagnostic.config({
				virtual_text = false,
				underline = true,
			})

			local on_attach = function(_, bufnr)
				-- Print LSP started message
				print("LSP attached.")

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
				map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
				map("n", "<leader>gw", vim.lsp.buf.document_symbol, "Show document symbols")
				map("n", "<leader>gW", vim.lsp.buf.workspace_symbol, "Show workspace symbols")
				map("n", "<leader>af", vim.lsp.buf.code_action, "Show code actions")
				map("n", "<leader>ar", vim.lsp.buf.rename, "Rename symbol")
				map("n", "<leader>=", vim.lsp.buf.format, "Format document")
				map("n", "<leader>ai", vim.lsp.buf.incoming_calls, "Show incoming calls")
				map("n", "<leader>ao", vim.lsp.buf.outgoing_calls, "Show outgoing calls")
				map("n", "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics")
			end

			lspconfig["sourcekit"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure html server
			lspconfig["html"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure typescript server with plugin
			local exists, typescript = pcall(require, "typescript")

			if exists then
				typescript.setup({
					server = {
						capabilities = capabilities,
						on_attach = on_attach,
					},
				})
			end

			-- configure css server
			lspconfig["cssls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure tailwindcss server
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
				on_attach = on_attach,
				filetypes = { "python" },
			})

			lspconfig["eslint_d"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			})

			-- configure lua server (with special settings)
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { -- custom settings for lua
					Lua = {
						-- make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							-- make language server aware of runtime files
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- nvim-cmp related config

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
					{ name = "nvim_lsp" }, -- lsp
					{ name = "luasnip" }, -- snippets
					{ name = "codeium" },
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),
				-- configure lspkind for vs-code like icons
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = 50,
						ellipsis_char = "...",
						symbol_map = {
							Codeium = "",
						},
					}),
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			require("pankajgarkoti.plugins.lsp.null-ls")
		end
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("pankajgarkoti.plugins.lsp.mason")
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not mason_lspconfig_status then
				print("mason_lspconfig not installed")
				return
			end

			mason_lspconfig.setup({
				ensure_installed = {
					"tsserver",
					"html",
					"cssls",
					"tailwindcss",
					"emmet_ls",
					"pyright",
				},
				automatic_installation = true,
			})
		end
	},
	{
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
					"stylua",
					"eslint_d",
					"black"
				},
				-- auto-install configured formatters & linters (with null-ls)
				automatic_installation = true,
			})
		end
	},
})
