local opt = vim.opt -- options

-- line number config
opt.relativenumber = true
opt.number = true

-- tab options
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = false
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- splitting
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
