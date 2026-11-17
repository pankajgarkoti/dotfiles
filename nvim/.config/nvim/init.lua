-- Core
require("pankajgarkoti.core.keymaps")
require("pankajgarkoti.plugins.setup")
require("pankajgarkoti.core.options")

-- LSP ad-hoc config
-- require("pankajgarkoti.plugins.lsp.eslint-lspconfig")

-- autocmds
require("pankajgarkoti.core.autocmds")
require("pankajgarkoti.core.cmds")
-- require("pankajgarkoti.core.ts-native")

-- Utils & Prefs
require("pankajgarkoti.prefs.path_utils")

-- fix for floating window borders bg color mismatch
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })

-- Treesitter native: start highlighting for *any* filetype with a parser.
-- Missing parsers are auto-installed in the background via nvim-treesitter,
-- then attached to open buffers. All calls are pcall'd so a failure never
-- aborts the FileType autocmd chain (which would block LSP from attaching).
local ts_installing = {}

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf = args.buf
		if vim.bo[buf].buftype ~= "" then
			return -- skip terminals, prompts, quickfix, etc.
		end

		local ft = args.match
		local lang = vim.treesitter.language.get_lang(ft) or ft

		local function start_ts(b)
			local ok = pcall(vim.treesitter.start, b, lang)
			if ok and b == buf then
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
			return ok
		end

		if start_ts(buf) then
			return
		end

		-- Parser missing: install it in the background, then attach.
		local ok, ts = pcall(require, "nvim-treesitter")
		if not ok or ts_installing[lang] then
			return
		end
		if not vim.tbl_contains(ts.get_available(), lang) then
			return -- no parser exists for this language, nothing to do
		end

		ts_installing[lang] = true
		ts.install(lang):await(function(err)
			ts_installing[lang] = nil
			if err then
				vim.notify(("Treesitter install failed for %s: %s"):format(lang, err), vim.log.levels.WARN)
				return
			end
			vim.schedule(function()
				for _, b in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].ft == ft then
						start_ts(b)
					end
				end
			end)
		end)
	end,
})
