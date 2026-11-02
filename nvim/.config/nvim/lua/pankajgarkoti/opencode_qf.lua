local M = {}

local preview_group = vim.api.nvim_create_augroup("OpenCodeQuickfixPreview", { clear = true })
local splash_filetypes = {
	alpha = true,
	dashboard = true,
	starter = true,
	["mini.starter"] = true,
	["snacks_dashboard"] = true,
}

local function is_splash(win)
	local buf = vim.api.nvim_win_get_buf(win)
	if vim.bo[buf].modified then
		return false
	end

	if splash_filetypes[vim.bo[buf].filetype] then
		return true
	end

	if vim.bo[buf].buftype ~= "" or vim.api.nvim_buf_get_name(buf) ~= "" then
		return false
	end

	local lines = vim.api.nvim_buf_get_lines(buf, 0, 2, false)
	return #lines == 1 and lines[1] == ""
end

local function preview_window()
	local windows = vim.api.nvim_tabpage_list_wins(0)
	for _, win in ipairs(windows) do
		local ok, marked = pcall(vim.api.nvim_win_get_var, win, "opencode_qf_preview")
		local buf = vim.api.nvim_win_get_buf(win)
		if ok and marked and vim.bo[buf].buftype == "" then
			return win
		end
	end

	for _, win in ipairs(windows) do
		if is_splash(win) then
			vim.api.nvim_win_set_var(win, "opencode_qf_preview", true)
			return win
		end
	end

	vim.cmd("rightbelow vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_var(win, "opencode_qf_preview", true)
	return win
end

local function keep_only(win)
	vim.api.nvim_set_current_win(win)
	for _, other in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if other ~= win and vim.api.nvim_win_is_valid(other) then
			vim.api.nvim_win_hide(other)
		end
	end
end

local function positive_integer(value, name, index)
	if type(value) ~= "number" or value < 1 or value % 1 ~= 0 then
		error(("location %d has an invalid %s"):format(index, name))
	end
end

local function preview(item, target_win)
	if not item or not vim.api.nvim_win_is_valid(target_win) then
		return
	end

	vim.api.nvim_win_set_buf(target_win, item.bufnr)
	local line_count = vim.api.nvim_buf_line_count(item.bufnr)
	local line = math.min(item.lnum, line_count)
	local text = vim.api.nvim_buf_get_lines(item.bufnr, line - 1, line, false)[1] or ""
	local column = math.min(math.max(item.col - 1, 0), #text)
	vim.api.nvim_win_set_cursor(target_win, { line, column })
	vim.api.nvim_win_call(target_win, function()
		vim.cmd("normal! zz")
	end)
end

function M.show(payload)
	if type(payload) ~= "table" or type(payload.locations) ~= "table" or #payload.locations == 0 then
		error("payload must contain at least one location")
	end

	local items = {}
	local seen = {}

	for index, location in ipairs(payload.locations) do
		if type(location) ~= "table" or type(location.path) ~= "string" or location.path == "" then
			error(("location %d has an invalid path"):format(index))
		end

		positive_integer(location.line, "line", index)
		positive_integer(location.column or 1, "column", index)

		local path = vim.fs.normalize(location.path)
		local stat = (vim.uv or vim.loop).fs_stat(path)
		if not stat or stat.type ~= "file" then
			error(("location %d is not a readable file: %s"):format(index, path))
		end

		local column = location.column or 1
		local key = table.concat({ path, location.line, column }, "\0")
		if not seen[key] then
			local bufnr = vim.fn.bufadd(path)
			vim.fn.bufload(bufnr)
			table.insert(items, {
				bufnr = bufnr,
				lnum = location.line,
				col = column,
				text = location.text or (path .. ":" .. location.line),
			})
			seen[key] = true
		end
	end

	vim.fn.setqflist({}, "r", {
		title = payload.title or "OpenCode files",
		items = items,
	})

	local target_win = preview_window()
	preview(items[1], target_win)
	keep_only(target_win)
	vim.cmd("botright copen")

	local quickfix_win = vim.api.nvim_get_current_win()
	local quickfix_buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_clear_autocmds({ group = preview_group })
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = preview_group,
		buffer = quickfix_buf,
		callback = function()
			if vim.api.nvim_get_current_win() ~= quickfix_win then
				return
			end
			local index = vim.api.nvim_win_get_cursor(quickfix_win)[1]
			preview(items[index], target_win)
		end,
	})

	return #items
end

function M.load_file(payload_path)
	if type(payload_path) ~= "string" or payload_path == "" then
		error("payload path must be a non-empty string")
	end

	local ok, payload = pcall(vim.json.decode, table.concat(vim.fn.readfile(payload_path), "\n"))
	if not ok then
		error("could not decode OpenCode quickfix payload: " .. payload)
	end

	return M.show(payload)
end

return M
