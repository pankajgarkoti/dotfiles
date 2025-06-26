-- nvim/.config/nvim/lua/pankajgarkoti/core/daily_note.lua
local M = {}

---@class DailyNoteConfig
---@field base_dir string The root directory for notes. The feature is only active here.
---@field journal_path string The sub-directory within base_dir for journal entries.
---@field file_format string The format for the note's filename, using os.date patterns.
---@field dir_format string The format for the directory structure, using os.date patterns.
---@field template_path string | nil Optional path to a template file for new notes if yesterday's doesn't exist.

---@type DailyNoteConfig
M.config = {
	base_dir = vim.fn.expand("~/Desktop/notes"),
	journal_path = "Journal",
	file_format = "%Y-%m-%d.md",
	dir_format = "%Y/%m",
	template_path = nil, -- No template by default
}

--- Opens the daily note.
-- If it exists, it opens it.
-- If it doesn't exist, it creates it by copying yesterday's note.
-- If yesterday's note also doesn't exist, it creates an empty note (or from a template).
-- This function is only active when the current working directory is inside `config.base_dir`.
function M.open_daily_note()
	local cwd = vim.fn.getcwd()
	if not (cwd == M.config.base_dir or cwd:find(M.config.base_dir .. "/", 1, true) == 1) then
		vim.notify("Not in notes directory: " .. M.config.base_dir, vim.log.levels.WARN)
		return
	end

	local today = os.date("*t")
	local today_dir_path = M.config.base_dir .. "/" .. M.config.journal_path .. "/" .. os.date(M.config.dir_format, os.time(today))
	local today_filename = os.date(M.config.file_format, os.time(today))
	local today_path = today_dir_path .. "/" .. today_filename

	if vim.fn.filereadable(today_path) == 1 then
		vim.cmd("e " .. today_path)
		vim.notify("Opened today's note.", vim.log.levels.INFO)
		return
	end

	-- Create directory if it doesn't exist
	vim.fn.mkdir(today_dir_path, "p")

	-- Get yesterday's note path
	local yesterday_t = os.time(today) - (24 * 60 * 60)
	local yesterday = os.date("*t", yesterday_t)
	local yesterday_dir_path = M.config.base_dir .. "/" .. M.config.journal_path .. "/" .. os.date(M.config.dir_format, os.time(yesterday))
	local yesterday_filename = os.date(M.config.file_format, os.time(yesterday))
	local yesterday_path = yesterday_dir_path .. "/" .. yesterday_filename

	local content = ""
	if vim.fn.filereadable(yesterday_path) == 1 then
		local lines = vim.fn.readfile(yesterday_path)
		content = table.concat(lines, "\n")
		vim.notify("Created today's note from yesterday's.", vim.log.levels.INFO)
	elseif M.config.template_path and vim.fn.filereadable(M.config.template_path) == 1 then
		local lines = vim.fn.readfile(M.config.template_path)
		content = table.concat(lines, "\n")
		vim.notify("Created today's note from template.", vim.log.levels.INFO)
	else
		vim.notify("Yesterday's note not found. Creating an empty daily note.", vim.log.levels.INFO)
	end

	vim.fn.writefile(vim.split(content, "\n"), today_path)
	vim.cmd("e " .. today_path)
end

return M
