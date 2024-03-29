local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
-- Autocommand that reloads nvim whenever this is saved
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- comments
	use("nvim-lua/plenary.nvim")

	-- center the buffer
	use({ "shortcuts/no-neck-pain.nvim" })

	-- theme
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("navarasu/onedark.nvim")

	-- tabs
	use({ "folke/noice.nvim" })

	-- tmux + split window nav
	use("christoomey/vim-tmux-navigator")

	-- surround text with quotes and other stuff
	use("tpope/vim-surround")

	-- replace text with whatever you have in register
	use("vim-scripts/ReplaceWithRegister")

	-- comments
	use("numToStr/Comment.nvim")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- nice icons for code files etc.
	use("kyazdani42/nvim-web-devicons")

	-- status bar
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding using telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

	-- code completion
	use({ "neoclide/coc.nvim", branch = "release" })

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use("lukas-reineke/indent-blankline.nvim") --indentation lines

	-- configuring lsp servers
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side
	use("tpope/vim-fugitive") -- vim git plugin

	use("marko-cerovac/material.nvim")

	use("ThePrimeagen/harpoon")
	use("numToStr/FTerm.nvim")
	use("APZelos/blamer.nvim")

	-- Which Key?
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	})

	use({
		"Exafunction/codeium.vim",
		options = {
			language_server = "~/codeium_ls_v1",
		},
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<C-a>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	})

	use({ "MunifTanjim/nui.nvim" })
	use({ "rcarriga/nvim-notify" })
	use({ "sindrets/diffview.nvim" })

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
