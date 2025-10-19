return {
	"rcarriga/nvim-notify",
	lazy = true,
	config = function()
		require("notify").setup({
			background_color = "#000000",
			fps = 30,
			animate = false,
			icons = {
				DEBUG = "",
				ERROR = "",
				INFO = "",
				TRACE = "✎",
				WARN = "",
			},
			level = 2,
			minimum_width = 70,
			max_width = 100,
			render = "wrapped-compact",
			stages = "static",
			timeout = 2500,
			top_down = true,
		})
	end
}
