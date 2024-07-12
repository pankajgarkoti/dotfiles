local setup, notify = pcall(require, "notify")
if not setup then
	return
end

notify.setup({
	background_color = "#6d6d6d",
	fps = 30,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = "",
	},
	level = 2,
	minimum_width = 50,
	max_width = 100,
	render = "wrapped-compact",
	stages = "static",
	timeout = 2500,
	top_down = true,
})
