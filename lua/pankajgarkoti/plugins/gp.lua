local setup, gp = pcall(require, "gp")
if not setup then
	return
end

gp.setup({
	openai_api_key = os.getenv("OPENAI_API_KEY"),
	openai_api_endpoint = "https://api.openai.com/v1/chat/completions",
	cmd_prefix = "Gp",
	curl_params = {},
	state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/persisted",
	agents = {
		{
			name = "ChatGPT4",
			chat = true,
			command = false,
			model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "ChatGPT3-5",
			chat = true,
			command = false,
			model = { model = "gpt-3.5-turbo-1106", temperature = 1.1, top_p = 1 },
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "CodeGPT4",
			chat = false,
			command = true,
			model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
		{
			name = "CodeGPT3-5",
			chat = false,
			command = true,
			model = { model = "gpt-3.5-turbo-1106", temperature = 0.8, top_p = 1 },
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
	},

	chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
	chat_user_prefix = "🗨:",
	chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
	chat_topic_gen_prompt = "Summarize the topic of our conversation above"
		.. " in two or three words. Respond only with those words.",
	chat_topic_gen_model = "gpt-3.5-turbo-16k",
	chat_confirm_delete = true,
	chat_conceal_model_params = true,
	chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
	chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
	chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
	chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
	chat_finder_pattern = "topic ",
	chat_free_cursor = false,

	toggle_target = "vsplit",

	-- border can be "single", "double", "rounded", "solid", "shadow", "none"
	style_chat_finder_border = "single",
	style_chat_finder_margin_bottom = 8,
	style_chat_finder_margin_left = 1,
	style_chat_finder_margin_right = 2,
	style_chat_finder_margin_top = 2,
	style_chat_finder_preview_ratio = 0.5,

	-- styling for popup
	style_popup_border = "single",
	style_popup_margin_bottom = 8,
	style_popup_margin_left = 1,
	style_popup_margin_right = 2,
	style_popup_margin_top = 2,
	style_popup_max_width = 160,

	-- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
	-- command prompt prefix for asking user for input (supports {{agent}} template variable)
	command_prompt_prefix_template = "🤖 {{agent}} ~ ",
	command_auto_select_response = true,

	-- templates
	template_selection = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
	template_rewrite = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should replace the selection above.",
	template_append = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
	template_prepend = "I have the following from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
	template_command = "{{command}}",

	whisper_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_whisper",
	-- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
	-- decibels are negative, the recording is normalized to -3dB =>
	-- increase this number to pick up more (weaker) sounds as possible speech
	-- decrease this number to pick up only louder sounds as possible speech
	-- you can disable silence trimming by setting this a very high number (like 1000.0)
	whisper_silence = "1.75",
	-- whisper max recording time (mm:ss)
	whisper_max_time = "05:00",
	-- whisper tempo (1.0 is normal speed)
	whisper_tempo = "1.75",
	-- The language of the input audio, in ISO-639-1 format.
	whisper_language = "en",

	-- image generation settings
	-- image prompt prefix for asking user for input (supports {{agent}} template variable)
	image_prompt_prefix_template = "🖌️ {{agent}} ~ ",
	-- image prompt prefix for asking location to save the image
	image_prompt_save = "🖌️💾 ~ ",
	-- default folder for saving images
	image_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_images",
	-- default image agents (model + settings)
	-- to remove some default agent completely set it just with the name like:
	-- image_agents = {  { name = "DALL-E-3-1024x1792-vivid" }, ... },
	image_agents = {
		{
			name = "DALL-E-3-1024x1024-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-vivid",
			model = "dall-e-3",
			quality = "standard",
			style = "vivid",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-natural",
			model = "dall-e-3",
			quality = "standard",
			style = "natural",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-vivid-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "vivid",
			size = "1024x1792",
		},
		{
			name = "DALL-E-3-1024x1024-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1024x1024",
		},
		{
			name = "DALL-E-3-1792x1024-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1792x1024",
		},
		{
			name = "DALL-E-3-1024x1792-natural-hd",
			model = "dall-e-3",
			quality = "hd",
			style = "natural",
			size = "1024x1792",
		},
	},

	-- example hook functions (see Extend functionality section in the README)
	hooks = {
		InspectPlugin = function(plugin, params)
			local bufnr = vim.api.nvim_create_buf(false, true)
			local copy = vim.deepcopy(plugin)
			local key = copy.config.openai_api_key
			copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
			local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
			local params_info = string.format("Command params:\n%s", vim.inspect(params))
			local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
			vim.api.nvim_win_set_buf(0, bufnr)
		end,

		-- GpImplement rewrites the provided selection/range based on comments in it
		Implement = function(gp, params)
			local template = "Having following from {{filename}}:\n\n"
				.. "```{{filetype}}\n{{selection}}\n```\n\n"
				.. "Please rewrite this according to the contained instructions."
				.. "\n\nRespond exclusively with the snippet that should replace the selection above."

			local agent = gp.get_command_agent()
			gp.info("Implementing selection with agent: " .. agent.name)

			gp.Prompt(
				params,
				gp.Target.rewrite,
				nil, -- command will run directly without any prompting for user input
				agent.model,
				template,
				agent.system_prompt
			)
		end,

		-- your own functions can go here, see README for more examples like
		-- :GpExplain, :GpUnitTests.., :GpTranslator etc.

		-- -- example of making :%GpChatNew a dedicated command which
		-- -- opens new chat with the entire current buffer as a context
		-- BufferChatNew = function(gp, _)
		-- 	-- call GpChatNew command in range mode on whole buffer
		-- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
		-- end,

		-- -- example of adding command which opens new chat dedicated for translation
		-- Translator = function(gp, params)
		-- 	local agent = gp.get_command_agent()
		-- 	local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
		-- 	gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
		-- end,

		-- -- example of adding command which writes unit tests for the selected code
		-- UnitTests = function(gp, params)
		-- 	local template = "I have the following code from {{filename}}:\n\n"
		-- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
		-- 		.. "Please respond by writing table driven unit tests for the code above."
		-- 	local agent = gp.get_command_agent()
		-- 	gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
		-- end,

		-- -- example of adding command which explains the selected code
		-- Explain = function(gp, params)
		-- 	local template = "I have the following code from {{filename}}:\n\n"
		-- 		.. "```{{filetype}}\n{{selection}}\n```\n\n"
		-- 		.. "Please respond by explaining the code above."
		-- 	local agent = gp.get_chat_agent()
		-- 	gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
		-- end,
	},
})
