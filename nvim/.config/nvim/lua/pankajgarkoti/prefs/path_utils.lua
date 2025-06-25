--- @return string
--- Get the path to the python executable in the current virtual environment.
--- If the current directory is not in a virtual environment, return python3 default path.
--- The path is determined by running `which python3` in the current directory.
local get_venv_python_path = function()
	local command_output = vim.fn.system('which python3')
	local path = vim.trim(command_output)
	local should_return_default = (path == nil) or (path == "")
	if should_return_default then
		return "python3"
	else
		return path
	end
end

vim.g.python3_host_prog = get_venv_python_path()
