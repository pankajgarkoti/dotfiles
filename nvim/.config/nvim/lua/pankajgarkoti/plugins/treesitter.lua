-- import nvim-treesitter plugin safely
local status, config = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

config.setup({
	highlight = { enable = true },
	indent = { enable = true },
	autotag = { enable = true },
	ensure_installed = {
		"lua",
		"markdown",
		"markdown_inline",
		"yaml",
		"json",
		"python",
		"javascript",
		"typescript",
		"tsx",
		"yaml",
		"html",
		"css",
		"markdown",
		"svelte",
		"graphql",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"gitignore"
	},
	auto_install = true,
})
