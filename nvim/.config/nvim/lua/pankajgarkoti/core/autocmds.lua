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

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "set wrap",
})
