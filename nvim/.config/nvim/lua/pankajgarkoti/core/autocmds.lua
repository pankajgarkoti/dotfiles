-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "lua", "python", "javascript", "typescript", "rust", "go" }, -- Add your desired filetypes here
-- 	callback = function()
-- 		local exists, outline = pcall(require, "outline")
-- 		if not exists then return end
-- 		vim.defer_fn(function()
-- 			outline.open()
-- 		end, 500) -- Small delay to ensure LSP is ready
-- 	end,
-- })

vim.api.nvim_create_autocmd('BufDelete', {
	callback = function()
		-- Count listed buffers (ignoring unlisted ones like NvimTree, etc.)
		local listed = vim.fn.getbufinfo({ buflisted = 1 })
		-- If no listed buffers, and we're not already in Starter
		if #listed == 0 and vim.bo.filetype ~= 'starter' then
			-- Delay to let buffer actually close
			vim.schedule(function()
				local exists, starter = pcall(require, "mini.starter")
				if not exists then return end
				starter.open()
			end)
		end
	end
})
