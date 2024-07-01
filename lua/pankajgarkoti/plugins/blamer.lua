local setup, blamer = pcall(require, "blamer")
if not setup then
	return
end

blamer.setup({
	blamer_enabled = 1,
	blamer_delay = 0,
	blamer_show_in_visual_modes = 1,
	blamer_relative_time = 1,
	blamer_prefix = " >> ",
})
