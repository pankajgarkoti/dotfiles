return {
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
}

