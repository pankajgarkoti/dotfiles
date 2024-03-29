-- Core
require("pankajgarkoti.plugins-setup")
require("pankajgarkoti.core.options")
require("pankajgarkoti.core.keymaps")
-- require("pankajgarkoti.core.neovide")
-- require("pankajgarkoti.core.colorscheme_material")
-- require("pankajgarkoti.core.colorscheme_catppuccin")
-- require("pankajgarkoti.core.colorscheme_gruvbox")
require("pankajgarkoti.core.colorscheme_onedark")

-- Plugins
require("pankajgarkoti.plugins.comment")
require("pankajgarkoti.plugins.nvim-tree")
require("pankajgarkoti.plugins.lualine")
require("pankajgarkoti.plugins.telescope")
require("pankajgarkoti.plugins.CoC.coc")
require("pankajgarkoti.plugins.treesitter")
require("pankajgarkoti.plugins.gitsigns")
require("pankajgarkoti.plugins.lsp.mason")
require("pankajgarkoti.plugins.lsp.null-ls")
require("pankajgarkoti.plugins.fterm")
require("pankajgarkoti.plugins.no-neck-pain")
require("pankajgarkoti.plugins.noice")
require("pankajgarkoti.plugins.notify")
require("pankajgarkoti.plugins.blamer")
require("pankajgarkoti.plugins.refactoring")

-- Patches
-- Patch for codeium interfering with autocomplete popup behaviour
vim.g.codeium_no_map_tab = 1
