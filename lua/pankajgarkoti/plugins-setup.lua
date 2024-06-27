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
					transparency = false,
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
					-- Disable all undercurls
					if highlight.undercurl then
						highlight.undercurl = false
					end

					-- Change palette colour
					if highlight.fg == palette.pine then
						highlight.fg = palette.foam
					end
				end,
			})

			vim.cmd("colorscheme rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-dawn")
		end,
	},
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
					["core.dirman"] = {
						config = {
							workspaces = {
								ws = "~/Desktop/notes/work/",
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
		opts = {
			keymaps = {
				up_and_jump = '<up>',
				down_and_jump = '<down>',
			}
		},
	},
	"nvim-lua/plenary.nvim",
	"shortcuts/no-neck-pain.nvim",
	"folke/noice.nvim",
	"christoomey/vim-tmux-navigator",
	-- "tpope/vim-surround",
	"vim-scripts/ReplaceWithRegister",
	-- "numToStr/Comment.nvim",
	"nvim-tree/nvim-tree.lua",
	"kyazdani42/nvim-web-devicons",
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		init = function()
			-- disable until lualine loads
			vim.opt.laststatus = 0
		end,
		opts = function()
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
			local selected_theme = themes.ice_blue
			-- local selected_theme = themes.stone_blue
			-- local selected_theme = themes.pebble_grey
			-- local selected_theme = themes.silver_wave

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

			-- insert component
			local function insert_component(section, component)
				table.insert(section, component)
			end

			-- active left section
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
				padding = { left = 1, right = 1 },
				separator = { right = "▓▒░" },
			})
			insert_component(config.sections.lualine_c, {
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.fg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { right = "▓▒░", left = "▓▒░" },
				symbols = {
					modified = "󰶻 ",
					readonly = " ",
					unnamed = " ",
					newfile = " ",
				},
			})
			insert_component(config.sections.lualine_c, {
				"branch",
				icon = "",
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 0, right = 0 },
				separator = { right = "▓▒░", left = "░▒▓" },
			})

			-- active right section
			insert_component(config.sections.lualine_x, {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				colored = false,
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { right = "▓▒░", left = "░▒▓" },
			})
			insert_component(config.sections.lualine_x, {
				"searchcount",
				color = { fg = colors.bg, bg = colors.accent },
				padding = { left = 1, right = 1 },
				separator = { right = "▓▒░", left = "░▒▓" },
			})
			insert_component(config.sections.lualine_x, {
				"location",
				color = { fg = colors.fg, bg = colors.accent },
				padding = { left = 1, right = 0 },
				separator = { left = "░▒▓" },
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
				separator = { right = "▓▒░" },
			})
			insert_component(config.sections.lualine_x, {
				"o:encoding",
				fmt = string.upper,
				cond = conditions.hide_in_width,
				padding = { left = 1, right = 1 },
				color = { fg = colors.bg, bg = colors.accent },
			})
			insert_component(config.sections.lualine_x, {
				"fileformat",
				fmt = string.lower,
				icons_enabled = false,
				cond = conditions.hide_in_width,
				color = { fg = colors.bg, bg = colors.accent },
				separator = { right = "░" },
				padding = { left = 0, right = 1 },
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
			require("mini.comment").setup()
			require("mini.align").setup()
			require("mini.diff").setup()
			require("mini.git").setup()
			require("mini.notify").setup(
				{
					timeout = 5000,
					window = {
						config = {},
						max_width_share = 0.333,
						winblend = 25,
					},
					lsp_progress = {
						enable = true,
						duration_last = 1000,
					},
				}
			)

			-- require("mini.indentscope").setup(
			-- 	{
			-- 		draw = {
			-- 			animation = require("mini.indentscope").gen_animation.linear({ duration = 100, unit = 'total' }),
			-- 		},
			-- 		options = {
			-- 			border = 'both',
			-- 			indent_at_cursor = true,
			-- 			try_as_border = true,
			-- 		},
			-- 	}
			-- )
		end
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
					enable = true,
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
					path = animate.gen_path.walls(),
				},
				resize = {
					enable = false,
					timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
				},
				scroll = {
					enable = false,
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
			-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			-- 	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
			-- 	callback = function()
			-- 		vim.diagnostic.open_float(nil, { focus = false })
			-- 	end
			-- })

			vim.diagnostic.config({
				virtual_text = true,
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
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>tr",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>trb",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>ts",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>tcl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	}
})
