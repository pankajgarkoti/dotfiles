-- Core
require("pankajgarkoti.core.keymaps")
require("pankajgarkoti.plugins.setup")
require("pankajgarkoti.core.options")

-- LSP ad-hoc config
require("pankajgarkoti.plugins.lsp.eslint-lspconfig")

-- autocmds
require("pankajgarkoti.core.autocmds")
require("pankajgarkoti.core.cmds")

-- Utils & Prefs
require("pankajgarkoti.prefs.path_utils")

-- fix for floating window borders bg color mismatch
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
