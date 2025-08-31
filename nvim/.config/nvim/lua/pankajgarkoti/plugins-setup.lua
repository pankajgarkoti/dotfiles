local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


return require("lazy").setup({
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	},
	"nvim-lua/plenary.nvim",
	"shortcuts/no-neck-pain.nvim",
	{
		"folke/noice.nvim",
		lazy = false,
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = false,
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30,
					view = "mini",
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ "<leader>sn",  "",                                                                            desc = "+noice" },
			{ "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
			{ "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
			{ "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
			{ "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
			{ "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
			{ "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
			{ "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
			{ "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
		},
		config = function(_, opts)
			-- HACK: noice shows messages from before it was enabled,
			-- but this is not ideal when Lazy is installing plugins,
			-- so clear the messages in this case.
			if vim.o.filetype == "lazy" then
				vim.cmd([[messages clear]])
			end
			require("noice").setup(opts)
		end,
	},
	"MunifTanjim/nui.nvim",
	"christoomey/vim-tmux-navigator",
	"vim-scripts/ReplaceWithRegister",
	{
		"nvim-tree/nvim-tree.lua", lazy = true
	},
	{
		"nvim-tree/nvim-web-devicons", lazy = true
	},
	{
		"nvim-lualine/lualine.nvim",
		lazy         = false,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		init         = function()
			vim.opt.laststatus = 0
		end,
		opts         = function()
			local themes = {
				ocean_breeze = { bg = "#1e3a5f", fg = "#c5d7e5", accent = "#3c9dd0" },
				forest_glade = { bg = "#2e4a3d", fg = "#d4e6c3", accent = "#5ea24a" },
				sunset_glow = { bg = "#5a2e2a", fg = "#e5d1c5", accent = "#e57c3d" },
				solar_flare = { bg = "#3b3b00", fg = "#e5e5c7", accent = "#d4a82d" },
				berry_crush = { bg = "#4a2a3a", fg = "#e5c5d4", accent = "#c03d7c" },
				mint_fresh = { bg = "#2a4a4a", fg = "#c5e5e4", accent = "#3db08c" },
				midnight = { bg = "#0d0d0d", fg = "#cfcfcf", accent = "#4e4e4e" },
				purple_haze = { bg = "#2a2a4a", fg = "#d4c5e5", accent = "#7c3dc0" },
				golden_hour = { bg = "#5a4a2a", fg = "#e5d7c5", accent = "#e5b43d" },
				ice_blue = { bg = "#2a4a5a", fg = "#c5e5e5", accent = "#3dc0e5" },
				cloudy_sky = { bg = "#3c3f41", fg = "#dcdcdc", accent = "#657b83" },
				steel_blue = { bg = "#2c3e50", fg = "#bdc3c7", accent = "#2980b9" },
				pearl_grey = { bg = "#4f4f4f", fg = "#e0e0e0", accent = "#b0b0b0" },
				foggy_morning = { bg = "#4a4a4a", fg = "#e5e5e5", accent = "#8a8a8a" },
				silver_wave = { bg = "#5a5a5a", fg = "#f0f0f0", accent = "#b0b0b0" },
				blue_mist = { bg = "#1e3a4a", fg = "#c5d7e5", accent = "#2a82b5" },
				light_slate = { bg = "#2c2e3e", fg = "#c6c8d1", accent = "#4c5a69" },
				stone_blue = { bg = "#283845", fg = "#b4c2cc", accent = "#3d566e" },
				azure_dream = { bg = "#223344", fg = "#c8d2dd", accent = "#335577" },
				winter_sky = { bg = "#2e3d4d", fg = "#d1e0e5", accent = "#4a6070" },
				shadow_blue = { bg = "#2a3b4a", fg = "#b0c4de", accent = "#3b5a7d" },
				deep_sea = { bg = "#1f2a36", fg = "#a8b2c2", accent = "#31445e" },
				navy_pearl = { bg = "#1c2d3c", fg = "#b0bcc7", accent = "#3e5b6d" },
				ghost_white = { bg = "#f8f8ff", fg = "#696969", accent = "#dcdcdc" },
				pebble_grey = { bg = "#2c2c2c", fg = "#d3d3d3", accent = "#a9a9a9" },
				glacier_blue = { bg = "#273c4e", fg = "#c1d9e3", accent = "#3a607e" },
				marine_dusk = { bg = "#213040", fg = "#b3c6d0", accent = "#324a60" },
				marine_pebble = { bg = "#213040", fg = "#d3d3d3", accent = "#a9a9a9" },
			}

			-- choose a theme
			-- local selected_theme = themes.stone_blue
			-- local selected_theme = themes.glacier_blue
			-- local selected_theme = themes.silver_wave
			-- local selected_theme = themes.deep_sea
			-- local selected_theme = themes.midnight
			local selected_theme = themes.blue_mist

			local colors = {
				bg = selected_theme.bg,
				fg = selected_theme.fg,
				accent = selected_theme.accent,
			}

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 70
				end,
			}

			-- config
			local config = {
				options = {
					component_separators = "",
					section_separators = "",
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
			}

			local function insert_component(section, component)
				table.insert(section, component)
			end

			insert_component(config.sections.lualine_c, {
				function()
					local icon
					local ok, devicons = pcall(require, 'nvim-web-devicons')
					if ok then
						icon = devicons.get_icon(vim.fn.expand('%:t'))
						if icon == nil then
							icon = devicons.get_icon_by_filetype(vim.bo.filetype)
						end
					else
						if vim.fn.exists('*WebDevIconsGetFileTypeSymbol') > 0 then
							icon = vim.fn.WebDevIconsGetFileTypeSymbol()
						end
					end
					if icon == nil then
						icon = ''
					end
					return icon:gsub("%s+", "")
				end,
				color = { fg = colors.fg, bg = colors.accent },
				padding = { left = 1, right = 0 },
			})
			insert_component(config.sections.lualine_c, {
				"branch",
				icon = "",
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 1, right = 2 },
				separator = { right = "⸗", left = "⸗" },
			})
			insert_component(config.sections.lualine_c, {
				"filename",
				path = 1,
				cond = conditions.buffer_not_empty,
				color = { fg = colors.fg, bg = colors.bg, },
				padding = { left = 1, right = 1 },
				separator = { right = "⸗", left = "⸗" },
				symbols = {
					modified = "•",
					readonly = "",
					unnamed = "",
					newfile = "",
				},
			})
			insert_component(config.sections.lualine_x, {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				colored = false,
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { right = "⸗", left = "⸗" },
			})
			insert_component(config.sections.lualine_x, {
				"searchcount",
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { right = "⸗", left = "░▒▓" },
			})
			insert_component(config.sections.lualine_x, {
				"location",
				color = { fg = colors.fg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { left = "⸗" },
			})
			insert_component(config.sections.lualine_x, {
				function()
					local cur = vim.fn.line(".")
					local total = vim.fn.line("$")
					return string.format("%2d%%%%", math.floor(cur / total * 100))
				end,
				color = { fg = colors.fg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				cond = conditions.hide_in_width,
				separator = { left = "⸗", right = "⸗" },
			})

			return config
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
	},
	{
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
							["<C-k>"] = actions.move_selection_previous,       -- move to prev result
							["<C-j>"] = actions.move_selection_next,           -- move to next result
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
						hide_on_startup = true,
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
	},
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
	"marko-cerovac/material.nvim",
	"ThePrimeagen/harpoon",
	"numToStr/FTerm.nvim",
	{
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
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		},
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
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
				build = "make install_jsregexp",
			},
			{ "saadparwaiz1/cmp_luasnip" }, -- for autocompletion,
			{ "onsails/lspkind.nvim" },  -- Optional  -> Icons in autocompletion
			{ "dundalek/lazy-lsp.nvim" } -- Auto install lsp servers
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
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = true,
		priority = 1001,
		lazy = false,
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
			})

			vim.cmd("colorscheme catppuccin-mocha")
		end
	},
	{
		"rcarriga/nvim-notify",
		lazy = true,
		config = function()
			require("notify").setup({
				background_color = "#000000",
				fps = 30,
				animate = false,
				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "",
					TRACE = "✎",
					WARN = "",
				},
				level = 2,
				minimum_width = 70,
				max_width = 100,
				render = "wrapped-compact",
				stages = "static",
				timeout = 2500,
				top_down = true,
			})
		end
	},
	{
		"supermaven-inc/supermaven-nvim",
		enabed = true,
		config = function()
			require("supermaven-nvim").setup({
				color = {
					suggestion_color = "#ffffff",
					cterm = 244,
				},
				ignore_filetypes = { TelescopePrompt = true, norg = true },
				log_level = "off",             -- set to "off" to disable logging completely
				disable_inline_completion = false, -- disables inline completion for use with cmp disable_keymaps = false,
				keymaps = {
					accept_suggestion = "<C-a>",
					clear_suggestion = "<C-x>",
					accept_word = "<C-j>",
				},
			})
		end,
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
		config = function()
			vim.o.foldcolumn = '0' -- '0' is not bad
			vim.o.foldnestmax = 99
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', '<leader>za', require('ufo').openAllFolds)
			vim.keymap.set('n', '<leader>zc', require('ufo').closeAllFolds)

			require('ufo').setup()
		end
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
		config = function()
			require("render-markdown").setup({
				completions = { lsp = { enabled = true } },
				render_modes = { "n", "v" },
				anti_conceal = {
					enabled = false,
				},
			})
		end
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",                                                                 -- Optional: For using slash commands and variables in the chat buffer
			"nvim-telescope/telescope.nvim",                                                    -- Optional: For using slash commands
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
			{ "stevearc/dressing.nvim",                    opts = {} },                         -- Optional: Improves `vim.ui.select`
		},
		opts = {
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
				agent = {
					adapter = "anthropic",
				},
			},
			opts = { log_level = "INFO" },
			display = {
				chat = {
					show_settings = true,
				}
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						schema = {
							model = {
								default = "claude-sonnet-4-20250514",
							},
						},
					})
				end,
			},
		},
	},
	{
		"sindrets/diffview.nvim",
		lazy = true,
	},
	{
		"folke/trouble.nvim",
		opts = {
			auto_close = false,  -- auto close when there are no items
			auto_open = true,    -- auto open when there are items
			auto_preview = true, -- automatically open preview when on an item
			auto_refresh = true, -- auto refresh when open
			auto_jump = false,   -- auto jump to the item when there's only one
			focus = true,        -- Focus the window when opened
			restore = false,     -- restores the last location in the list when opening
			follow = true,       -- Follow the current item
			indent_guides = true, -- show indent guides
			max_items = 200,     -- limit number of items that can be displayed per section
			multiline = true,    -- render multi-line messages
			pinned = true,       -- When pinned, the opened trouble window will be bound to the current buffer
			warn_no_results = true, -- show a warning when there are no results
			open_no_results = true, -- open the trouble window when there are no results
		},
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"azorng/goose.nvim",
		config = function()
			require('goose').setup({
				default_global_keymaps = true, -- If false, disables all default global keymaps
				keymap = {
					global = {
						toggle = '<leader>gg',           -- Open goose. Close if opened
						open_input = '<leader>gi',       -- Opens and focuses on input window on insert mode
						open_input_new_session = '<leader>gI', -- Opens and focuses on input window on insert mode. Creates a new session
						open_output = '<leader>go',      -- Opens and focuses on output window
						toggle_focus = '<leader>gt',     -- Toggle focus between goose and last window
						close = '<leader>gq',            -- Close UI windows
						toggle_fullscreen = '<leader>gf', -- Toggle between normal and fullscreen mode
						select_session = '<leader>gs',   -- Select and load a goose session
						goose_mode_chat = '<leader>gmc', -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
						goose_mode_auto = '<leader>gma', -- Set goose mode to `auto`. (Default mode with full agent capabilities)
						configure_provider = '<leader>gp', -- Quick provider and model switch from predefined list
						diff_open = '<leader>gdf',       -- Opens a diff tab of a modified file since the last goose prompt
						diff_next = '<leader>g]',        -- Navigate to next file diff
						diff_prev = '<leader>g[',        -- Navigate to previous file diff
						diff_close = '<leader>gc',       -- Close diff view tab and return to normal editing
						diff_revert_all = '<leader>gra', -- Revert all file changes since the last goose prompt
						diff_revert_this = '<leader>grt', -- Revert current file changes since the last goose prompt
					},
					window = {
						submit = '<cr>',         -- Submit prompt
						close = '<esc>',         -- Close UI windows
						stop = '<C-c>',          -- Stop goose while it is running
						next_message = ']]',     -- Navigate to next message in the conversation
						prev_message = '[[',     -- Navigate to previous message in the conversation
						mention_file = '@',      -- Pick a file and add to context. See File Mentions section
						toggle_pane = '<tab>',   -- Toggle between input and output panes
						prev_prompt_history = '<up>', -- Navigate to previous prompt in history
						next_prompt_history = '<down>' -- Navigate to next prompt in history
					}
				},
				ui = {
					window_width = 0.3,  -- Width as percentage of editor width
					input_height = 0.3,  -- Input height as percentage of window height
					fullscreen = false,  -- Start in fullscreen mode (default: false)
					layout = "right",    -- Options: "center" or "right"
					floating_height = 0.8, -- Height as percentage of editor height for "center" layout
					display_model = true, -- Display model name on top winbar
					display_goose_mode = true -- Display mode on top winbar: auto|chat
				},
				providers = {}
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					anti_conceal = { enabled = false },
				},
			}
		},
	},
	{
		"pankajgarkoti/daily-notes.nvim",
		config = function()
			require("daily-notes").setup(
				{
					base_dir        = "~/Desktop/notes",               -- Your notes directory
					journal_path    = "Journal",                       -- Subdirectory for daily notes
					template_path   = "~/Desktop/notes/templates/daily.md", -- Optional templatea
					ignored_headers = { "Notes", "Logs" },
				})
		end,
		keys = {
			{ "<leader>dn", function() require("daily-notes").open_daily_note() end,       desc = "Open daily note" },
			{ "<leader>dk", function() require("daily-notes").open_adjacent_note(-1) end,  desc = "Previous daily note" },
			{ "<leader>dj", function() require("daily-notes").open_adjacent_note(1) end,   desc = "Next daily note" },
			{ "<leader>dm", function() require("daily-notes").create_tomorrow_note() end,  desc = "Create tomorrow's note" },
			{ "<leader>dc", function() require("daily-notes").configure_interactive() end, desc = "Configure daily notes" },
			{ "<leader>ll", function() require("daily-notes").insert_timestamp() end,      desc = "Insert timestamp" },
			{ "<leader>ln", function() require("daily-notes").insert_timestamp(true) end,  desc = "Insert timestamp on new line" },
		},
		cmd = {
			"DailyNote",
			"DailyNotePrev",
			"DailyNoteNext",
			"DailyNoteTomorrow",
			"DailyNoteConfig",
			"DailyNoteTimestamp",
		},
	}
})
