vim.opt.runtimepath:prepend(vim.fn.expand("~/.config/nvim"))

local fixture = vim.fn.tempname()
local payload = vim.fn.tempname()
vim.fn.termopen({ "sh", "-c", "sleep 30" })
local terminal_win = vim.api.nvim_get_current_win()
local terminal_buf = vim.api.nvim_get_current_buf()
vim.cmd("new")
local target_win = vim.api.nvim_get_current_win()
vim.api.nvim_set_current_win(terminal_win)
vim.fn.writefile({ "first", "second", "third" }, fixture)
vim.fn.writefile({
	vim.json.encode({
		title = "OpenCode test",
		locations = {
			{ path = fixture, line = 2, column = 3, text = "target" },
			{ path = fixture, line = 2, column = 3, text = "duplicate" },
			{ path = fixture, line = 3, column = 2, text = "next target" },
		},
	}),
}, payload)

local count = require("pankajgarkoti.opencode_qf").load_file(payload)
local list = vim.fn.getqflist({ items = 1, title = 1 })

assert(count == 2, "duplicate locations should be removed")
assert(list.title == "OpenCode test", "quickfix title should be preserved")
assert(#list.items == 2, "quickfix list should contain unique entries")
assert(list.items[1].lnum == 2, "line number should be exact")
assert(list.items[1].col == 3, "column number should be exact")
assert(list.items[1].text == "target", "quickfix text should be preserved")
assert(vim.api.nvim_buf_is_loaded(list.items[1].bufnr), "target buffer should be loaded")
assert(vim.bo.buftype == "quickfix", "quickfix window should retain focus")
assert(not vim.api.nvim_win_is_valid(terminal_win), "terminal window should no longer take up space")
assert(vim.api.nvim_buf_is_loaded(terminal_buf), "hidden terminal job should remain loaded")
assert(vim.api.nvim_win_get_buf(target_win) == list.items[1].bufnr, "splash window should become the preview")
assert(vim.api.nvim_win_get_cursor(target_win)[1] == 2, "first item should be previewed")
assert(#vim.api.nvim_tabpage_list_wins(0) == 2, "only the preview and quickfix windows should remain")

local quickfix_win = vim.api.nvim_get_current_win()
vim.api.nvim_win_set_cursor(quickfix_win, { 2, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", { buffer = vim.api.nvim_get_current_buf() })

local target_cursor = vim.api.nvim_win_get_cursor(target_win)
assert(vim.api.nvim_get_current_win() == quickfix_win, "preview should keep quickfix focus")
assert(vim.api.nvim_win_get_buf(target_win) == list.items[2].bufnr, "highlighted item should be previewed")
assert(
	target_cursor[1] == 3 and target_cursor[2] == 1,
	("preview cursor should use the exact location, got %d:%d"):format(target_cursor[1], target_cursor[2])
)

vim.cmd(".cc")
assert(vim.api.nvim_get_current_win() == target_win, "selecting an entry should focus its preview window")
assert(vim.api.nvim_win_is_valid(quickfix_win), "quickfix should remain open after selecting an entry")
vim.api.nvim_set_current_win(quickfix_win)
vim.api.nvim_win_set_cursor(quickfix_win, { 1, 0 })
vim.api.nvim_exec_autocmds("CursorMoved", { buffer = vim.api.nvim_get_current_buf() })
assert(vim.api.nvim_win_get_cursor(target_win)[1] == 2, "preview should resume after returning to quickfix")

vim.fn.delete(fixture)
vim.fn.delete(payload)
vim.cmd("qa!")
