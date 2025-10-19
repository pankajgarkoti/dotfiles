return {
	"pankajgarkoti/daily-notes.nvim",
	config = function()
		require("daily-notes").setup(
			{
				base_dir        = "~/Desktop/notes",                -- Your notes directory
				journal_path    = "Journal",                        -- Subdirectory for daily notes
				template_path   = "~/Desktop/notes/templates/daily.md", -- Optional templatea
				ignored_headers = { "Notes", "Logs" },
			})
	end,
	keys = {
		{ "<leader>dn", function() require("daily-notes").open_daily_note() end,       desc = "Open daily note" },
		{ "<leader>dk", function() require("daily-notes").open_adjacent_note(-1) end,  desc = "Previous daily note" },
		{ "<leader>dj", function() require("daily-notes").open_adjacent_note(1) end,   desc = "Next daily note" },
		{ "<leader>dm", function() require("daily-notes").create_tomorrow_note() end,  desc = "Create tomorrow's note" },
		{ "<leader>dc", function() require("daily-notes").configure_interactive() end, desc = "Configure daily notes" },
		{ "<leader>ll", function() require("daily-notes").insert_timestamp() end,      desc = "Insert timestamp" },
		{ "<leader>ln", function() require("daily-notes").insert_timestamp(true) end,  desc = "Insert timestamp on new line" },
	},
	cmd = {
		"DailyNote",
		"DailyNotePrev",
		"DailyNoteNext",
		"DailyNoteTomorrow",
		"DailyNoteConfig",
		"DailyNoteTimestamp",
	},
}
