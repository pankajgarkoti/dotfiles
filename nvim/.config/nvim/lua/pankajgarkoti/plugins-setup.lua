vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{ "navarasu/onedark.nvim",   lazy = false, priority = 1000 },
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default.
		version = "*", -- Pin Neorg to the latest stable release.
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.ui"] = {},
					["core.ui.calendar"] = {},
					["core.export"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								ws = "~/Desktop/notes",
							},
							index = "index.norg", -- The name of the main (root) .norg file
							autodetect = true,
							autochdir = true,
						}
					},
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
						}
					},
					["core.concealer"] = {
						config = {
							icons = {
								delimiter = {
									horizontal_line = {
										highlight = "@neorg.delimiters.horizontal_line",
									},
								},
								code_block = {
									-- If true will only dim the content of the code block (without the
									-- `@code` and `@end` lines), not the entirety of the code block itself.
									content_only = false,

									-- The width to use for code block backgrounds.
									--
									-- When set to `fullwidth` (the default), will create a background
									-- that spans the width of the buffer.
									--
									-- When set to `content`, will only span as far as the longest line
									-- within the code block.
									width = "fullwidth",

									-- Additional padding to apply to either the left or the right. Making
									-- these values negative is considered undefined behaviour (it is
									-- likely to work, but it's not officially supported).
									padding = {
										-- left = 20,
										-- right = 20,
									},

									-- If `true` will conceal (hide) the `@code` and `@end` portion of the code
									-- block.
									conceal = true,

									nodes = { "ranged_verbatim_tag" },
									highlight = "CursorLine",
									-- render = module.public.icon_renderers.render_code_block,
									insert_enabled = true,
								},
							},
						},
					},
				}
			})

			-- keymaps
			local opts = { noremap = true, silent = true }

			-- local function quickfix()
			-- 	vim.lsp.buf.code_action({
			-- 		filter = function(a) return a ~= nil end,
			-- 		apply = true
			-- 	})
			-- end

			vim.keymap.set('n', '<leader>njj', ":Neorg journal today<CR>", opts)
			vim.keymap.set('n', '<leader>njy', ":Neorg journal yesterday<CR>", opts)
			vim.keymap.set('n', '<leader>njt', ":Neorg journal tomorrow<CR>", opts)
			vim.keymap.set('n', '<leader>ntc', ":Neorg toc<CR>", opts)
		end,
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		event = "BufReadPost",
		config = function()
			local opts = {
				outline_window = { position = 'right', width = 20 },

				symbols = {
					icon_fetcher = function(_) return "" end,
				},

				outline_items = {
					show_symbol_lineno = true,
				},

				keymaps = {
					up_and_jump = '<up>',
					down_and_jump = '<down>',
				},

				symbol_folding = {
					autofold_depth = 4,
					auto_unfold = {
						hovered = false,
						only = true,
					},
					markers = { '', '' },
				},

				preview_window = {
					auto_preview = true,
					open_hover_on_preview = true,
					width = 30, -- Percentage or integer of columns
					min_width = 20, -- This is the number of columns
					relative_width = true,
					border = 'double',
					winhl = 'NormalFloat:',
					winblend = 0,
					live = false
				},
			}

			require("outline").setup(opts)
		end,
	},
	"nvim-lua/plenary.nvim",
	"shortcuts/no-neck-pain.nvim",
	{
		"folke/noice.nvim",
		event = "VeryLazy",
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
			local selected_theme = themes.midnight

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
				padding = { left = i1, right = 1 },
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
		'Exafunction/codeium.vim',
		enabled = false,
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set('i', '<C-a>', function() return vim.fn['codeium#Accept']() end,
				{ expr = true, silent = true })
			vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
				{ expr = true, silent = true })
			vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
				{ expr = true, silent = true })
			vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end,
				{ expr = true, silent = true })
		end
	},
	{
		'echasnovski/mini.nvim',
		version = '*',
		config = function()
			vim.o.laststatus = 3
			require("mini.starter").setup()
			require("mini.align").setup()
			require("mini.diff").setup()
			require("mini.git").setup()
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
						indent_at_cursor = true,
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
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function()
			-- don't use animate when scrolling with the mouse
			local mouse_scrolled = false
			for _, scroll in ipairs({ "Up", "Down" }) do
				local key = "<ScrollWheel" .. scroll .. ">"
				vim.keymap.set({ "", "i" }, key, function()
					mouse_scrolled = true
					return key
				end, { expr = true })
			end

			local animate = require("mini.animate")
			return {
				cursor = {
					enable = false,
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
					path = animate.gen_path.walls(),
				},
				resize = {
					enable = false,
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
				},
				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
					subscroll = animate.gen_subscroll.equal({
						predicate = function(total_scroll)
							if mouse_scrolled then
								mouse_scrolled = false
								return false
							end
							return total_scroll > 1
						end,
					}),
				},
			}
		end,
	},
	"sindrets/diffview.nvim",
	{
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-tree.lua",      -- (optional) to manage project files
			"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
		},
		config = function()
			require("xcodebuild").setup({})
		end,
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
			local configs = require("lspconfig/configs")
			local util = require("lspconfig/util")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true
			}

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

			lspconfig["sourcekit"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure html server
			lspconfig["html"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure typescript server
			lspconfig["tsserver"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "typescript", "typescriptreact", },
			})

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

			-- config for vue-language-server (volar)
			configs.volar = {
				default_config = {
					cmd = { 'vls --stdio' },
					filetypes = { 'vue' },
					root_dir = util.root_pattern('package.json', 'vue.config.js'),
					init_options = {
						typescript = {
							serverPath = '/usr/lib/node_modules/typescript/lib/tsserverlibrary.js',
						},
						languageFeatures = {
							references = true,
							definition = true,
							typeDefinition = true,
							callHierarchy = true,
							hover = true,
							rename = true,
							signatureHelp = true,
							codeAction = true,
							completion = {
								defaultTagNameCase = 'both',
								defaultAttrNameCase = 'kebabCase',
								getDocumentNameCasesRequest = true,
								getDocumentSelectionRequest = true,
							},
							documentLink = true,
							codeLens = true,
							diagnostics = true,
						},
						documentFeatures = {
							selectionRange = true,
							foldingRange = true,
							documentSymbol = true,
							documentColor = true,
							documentFormatting = {
								defaultPrintWidth = 100,
								getDocumentPrintWidthRequest = true,
							},
						},
					},
				},
			}

			lspconfig["volar"].setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "vue" },
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
					{ name = "nvim_lsp" }, -- lsp
					{ name = "supermaven" }, -- supermaven copilot
					{ name = "luasnip" }, -- snippets
					-- { name = "codeium" },
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" },  -- file system paths
				}),
				-- configure lspkind for vs-code like icons
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
	{
		"rose-pine/neovim",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "auto",  -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
					migrations = true,   -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},

				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",

					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",

					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",

					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},

				highlight_groups = {
					Comment = { fg = "foam" },
					VertSplit = { fg = "muted", bg = "muted" },
				},

				before_highlight = function(group, highlight, palette)
					if highlight.undercurl then
						highlight.undercurl = false
					end

					if highlight.fg == palette.pine then
						highlight.fg = palette.foam
					end
				end,
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		enabled = true,
		priority = 1001,
		lazy = false,
		config = function()
			local variants = {
				latte = "latte",
				frappe = "frappe",
				macchiato = "macchiato",
				mocha = "mocha"
			}
			require("catppuccin").setup({
				transparent_background = true,
			})
		end
	},
	{
		"rcarriga/nvim-notify",
		lazy = true,
	},
	{
		"supermaven-inc/supermaven-nvim",
		enabed = true,
		-- commit = 'df3ecf7',
		config = function()
			require("supermaven-nvim").setup({
				color = {
					suggestion_color = "#ffffff",
					cterm = 244,
				},
				ignore_filetypes = { TelescopePrompt = true, norg = true },
				log_level = "info",            -- set to "off" to disable logging completely
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
		"zenbones-theme/zenbones.nvim",
		enabed = false,
		lazy = false,
		priority = 1000,
		dependencies = {
			"rktjmp/lush.nvim"
		},
		config = function()
			vim.g.nordbones = { transparent_background = true }
			vim.g.zenbones = { transparent_background = true }
		end
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
		config = function()
			local ufo = require('ufo')

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
		'mg979/vim-visual-multi'
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		opts = {},
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- Optional
			{
				"stevearc/dressing.nvim",   -- Optional: Improves the default Neovim UI
				opts = {},
			},
		},
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = "openai",
					},
					inline = {
						adapter = "openai",
					},
					agent = {
						adapter = "openai",
					},
				}
			})

			vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("v", "<leader>aa", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })

			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
		end
	},
	-- {
	-- 	"3rd/image.nvim",
	-- 	lazy = true,
	-- 	opts = {
	-- 		backend = "kitty",
	-- 		max_width = 100,
	-- 		max_height = 12,
	-- 		max_height_window_percentage = math.huge,
	-- 		max_width_window_percentage = math.huge,
	-- 		window_overlap_clear_enabled = false,
	-- 		window_overlap_clear_ft_ignore = {
	-- 			"cmp_menu",
	-- 			"cmp_docs",
	-- 			"",
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"benlubas/molten-nvim",
	-- 	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	-- 	dependencies = { "3rd/image.nvim" },
	-- 	build = ":UpdateRemotePlugins",
	-- 	lazy = true,
	-- 	init = function()
	-- 		vim.g.molten_image_provider = "image.nvim"
	-- 		vim.g.molten_output_win_max_height = 20
	-- 	end,
	-- },
	{ "ellisonleao/gruvbox.nvim" },
	-- {
	-- 	"GCBallesteros/jupytext.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("jupytext").setup(
	-- 			{
	-- 				style = "hydrogen",
	-- 				output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
	-- 				force_ft = nil,       -- Default filetype. Don't change unless you know what you are doing
	-- 				custom_language_formatting = {},
	-- 			}
	-- 		)
	-- 	end,
	-- },
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		'mfussenegger/nvim-dap',
		lazy = true,
		dependencies = {
			'nvim-telescope/telescope-dap.nvim',
			'mfussenegger/nvim-dap-python',
			'nvim-dap-virtual-text',
			'nvim-dap-ui',
		},
		config = function()
			local dap = require('dap')

			local keymaps = { {
				d = {
					c = { '<Cmd>lua require"dap".continue()<CR>', 'continue' },
					l = { '<Cmd>lua require"dap".run_last()<CR>', 'run last' },
					q = { '<Cmd>lua require"dap".terminate()<CR>', 'terminate' },
					h = { '<Cmd>lua require"dap".stop()<CR>', 'stop' },
					n = { '<Cmd>lua require"dap".step_over()<CR>', 'step over' },
					s = { '<Cmd>lua require"dap".step_into()<CR>', 'step into' },
					S = { '<Cmd>lua require"dap".step_out()<CR>', 'step out' },
					b = { '<Cmd>lua require"dap".toggle_breakpoint()<CR>', 'toggle br' },
					B = { '<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', 'set br condition' },
					p = { '<Cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', 'set log br' },
					r = { '<Cmd>lua require"dap".repl.open()<CR>', 'REPL open' },
					k = { '<Cmd>lua require"dap".up()<CR>', 'up callstack' },
					j = { '<Cmd>lua require"dap".down()<CR>', 'down callstack' },
					i = { '<Cmd>lua require"dap.ui.widgets".hover()<CR>', 'info' },
					['?'] = { '<Cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>', 'scopes' },
					f = { '<Cmd>Telescope dap frames<CR>', 'search frames' },
					C = { '<Cmd>Telescope dap commands<CR>', 'search commands' },
					L = { '<Cmd>Telescope dap list_breakpoints<CR>', 'search breakpoints' },
				},
			} }

			map_keys(keymaps)

			vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
			vim.fn.sign_define('DapStopped', { text = '🚏', texthl = '', linehl = '', numhl = '' })
			dap.defaults.fallback.terminal_win_cmd = 'tabnew'
			dap.defaults.fallback.focus_terminal = true

			local setup, dap_python = pcall(require, 'dap-python')

			if setup then
				dap_python.setup()
				dap_python.test_runner = 'pytest'
				dap_python.default_port = 38000
				dap.listeners.after.event_initialized["dapui_config"] = function()
					require('dapui').open()
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					require('dapui').close()
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					require('dapui').close()
				end
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		lazy = true,
		init = function()
			local keymaps_n = {
				d = {
					u = { '<Cmd>lua require"dapui".toggle()<CR>', 'ui toggle' },
					e = { '<Cmd>lua require"dapui".eval()<CR>', 'eval' },
					E = { '<Cmd>lua require"dapui".float_element()<CR>', 'float element' },
				},
			}

			local keymaps_v = {
				d = {
					e = { '<Cmd>lua require"dapui".eval()<CR>', 'eval' },
					E = { '<Cmd>lua require"dapui".float_element()<CR>', 'float element' },
				},
			}

			map_keys(keymaps_n, {})
			map_keys(keymaps_v, {})
		end,
		config = true,
	},
	{
		'theHamsta/nvim-dap-virtual-text',
		lazy = true,
		config = function()
			require('nvim-dap-virtual-text').setup()
			vim.cmd('highlight! NvimDapVirtualText guifg=#7c6f64 gui=italic')
		end
	}
})
