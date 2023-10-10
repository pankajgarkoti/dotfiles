local setup, notify = pcall(require, "notify")
if not setup then
	return
end

notify.setup({
	background_color = "#6d6d6d",
})
