local status, _ = pcall(require, "codecompanion")
if not status then
	print(
		"Creation of the prompt library failed. Please install the CodeCompanion plugin first."
	)
	return
end

local keywords = {
	languages = { "Python", "JavaScript", "TypeScript", "Go", "Lua", "Lua (Neovim)", "Node.js", "Java", "C++", "C", "C#", "Ruby", "PHP", "Swift", "Kotlin", "Rust", "Dart", "Haskell", "Scala", "Elixir", "Julia", "Objective-C", "R", "MATLAB", "Perl", "Groovy", "F#", "Scala", "Kotlin", "Clojure", "F#" },
	frameworks = { "Django", "FastAPI", "React", "Vue", "Svelte", "Gin", "Flask", "Express.js", "Nest.js", "Sails.js", "Koa.js", "Node.js", "Express", "Koa", "Sails", "Nest", "Fastify", "Hapi.js", "Loopback.js", "Pandas", "Numpy", "SciPy", "Pytest", "Docker", "Kubernetes", "GraphQL", "SQL", "WebAssembly" },
	topics = { "Machine Learning", "Security Best Practices", "Performance Tuning", "Concurrency and Parallelism", "Schema Optimization", "Event-Driven Architecture", "Test ", "Github CI/CD Pipelines", "Functional Programming" },
	principles = { "SOLID Principles", "REST API Design Fundamentals", "DRY Principles", "Data Validation", "Error Handling", "Dependency Injection", "Readability", "Maintainability", "Variable Naming", "Funcional Programming", "Side Effects", "Mutability", "Space Complexity", "Time Complexity" },
}

local function create_boilerplate_prompts(topics)
	for _, language_framework in ipairs(topics) do
		table.insert(
			_G.PROMPT_LIBRARY_LIST,
			{
				strategy = "inline",
				description = string.format("Generate boilerplate for %s", language_framework),
				opts = {
					pre_hook = function()
						local bufnr = vim.api.nvim_create_buf(true, false)
						vim.api.nvim_buf_set_option(bufnr, "filetype", language_framework:lower())
						vim.api.nvim_set_current_buf(bufnr)
						return bufnr
					end,
					short_name = string.format("Boilerplate: %s", language_framework:lower()),
				},
				prompts = {
					{
						role = "system",
						content =
						"Please set up the necessary imports, boilerplate functions and classes for the task at hand as described by the user. Adhere to the best practices and add comments as you go."
					},
					{
						role = "user",
						content = function()
							return "I need you to setup the basic boilerplate code for" ..
									language_framework:lower() ..
									" and please make sure it sets up the structure according to the best practices suitable for as well as the existing codebase."
						end
					},
				}
			})
	end
end

local function create_explanation_prompts(topics)
	for _, topic in ipairs(topics) do
		table.insert(
			_G.PROMPT_LIBRARY_LIST,
			{
				strategy = "chat",
				description = string.format("Get explanation for %s from an LLM", topic),
				opts = {
					modes = { "v" },
					short_name = string.format("Explain: %s", topic:lower()),
					auto_submit = true,
					stop_context_insertion = true,
					user_prompt = true,
				},
				prompts = {
					{
						role = "system",
						content = function()
							return "Act as a senior developer specializing in " ..
									topic ..
									", given a code snippet please answer specific questions about it and provide concise explanations and usage examples."
						end,
					},
					{
						role = "user",
						content = function(ctx)
							local text = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
							return "I have the following code:\n\n```" ..
									ctx.filetype ..
									"\n" .. text .. "\n```\n\n. Please explain what the purpose of the code is. Be detailed."
						end,
						opts = {
							contains_code = true,
						},
					},
				},
			})
	end
end

local function create_debugging_prompts(topics)
	for _, language_framework in ipairs(topics) do
		table.insert(
			_G.PROMPT_LIBRARY_LIST,
			{
				strategy = "chat",
				description = string.format("Debug %s code with LLM assistance", language_framework),
				opts = {
					modes = { "v" },
					short_name = string.format("Debug: %s", language_framework:lower()),
					auto_submit = false,
					stop_context_insertion = true,
					user_prompt = true,
				},
				prompts = {
					{
						role = "system",
						content = function()
							return "You are an experienced developer specializing in identifying potential code issues in " ..
									language_framework ..
									" code. Your goal is to provide clear and concise feedback on the code, highlighting any potential issues or areas for improvement. Please ensure that your feedback is actionable and provides specific suggestions for how to address the identified issues."
						end,
					},
					{
						role = "user",
						content = function(ctx)
							local text = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
							return "Please review the following " ..
									language_framework ..
									" code and let me know if there are any potential issues or areas for improvement:\n\n" ..
									"```" .. ctx.filetype .. "\n" .. text .. "\n```\n\n"
						end,
						opts = {
							contains_code = true,
						},
					},
				},
			})
	end
end

local function create_refactor_prompts(topics, modifiers)
	for _, language_framework in ipairs(topics) do
		for _, modifier in ipairs(modifiers) do
			table.insert(
				_G.PROMPT_LIBRARY_LIST,
				{
					opts = {
						modes = { "v" },
						short_name = string.format("Refactor: %s", language_framework:lower()),
						auto_submit = true,
						stop_context_insertion = true,
						user_prompt = true,
					},
					strategy = "chat",
					description = string.format("Refactor %s code in accordance with %s", language_framework, modifier),
					prompts = {
						{
							role = "system",
							content = function()
								return "You are an experienced developer specializing in improving the performance and readability of " ..
										language_framework ..
										" code. Your goal is to refactor the code to make it easier to read and maintain. Any potential performance enhancements should be implemented and marked with a comment. Be very careful while updating business logic and make sure all side effects of your changes are accounted for."
							end,
						},
						{
							role = "user",
							content = function(ctx)
								local text = require("codecompanion.helpers.actions").get_code(ctx.start_line, ctx.end_line)
								return "Please analyze and suggest improvements for the following " ..
										language_framework .. " code:\n\n" ..
										"```" .. ctx.filetype .. "\n" .. text .. "\n```\n\n" ..
										"Please take into account" .. modifier .. " while doing so."
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				})
		end
	end
end

-- Populates the prompt library dictionary and returns it.
local function create_prompt_library()
	if _G.PROMPT_LIBRARY_LIST == nil then
		_G.PROMPT_LIBRARY_LIST = {}
	end

	local boilerplate = vim.tbl_extend("force", keywords.languages, keywords.frameworks)
	local explanation = vim.tbl_extend("force", keywords.languages, keywords.frameworks, keywords.topics)
	local refactor = vim.tbl_extend("keep", keywords.languages, keywords.frameworks)

	create_boilerplate_prompts(boilerplate)
	create_explanation_prompts(explanation)
	create_debugging_prompts(boilerplate)
	create_refactor_prompts(refactor, keywords.principles)


	if #_G.PROMPT_LIBRARY_LIST == 0 then
		return nil
	end

	return _G.PROMPT_LIBRARY_LIST
end

-- Populates the prompt library dictionary and assigns it to the global variable CC_PROMPT_LIBRARY
-- Also returns the prompt library dictionary
_G.load_code_companion_prompts = function()
	create_prompt_library()

	_G.CC_PROMPT_LIBRARY = {}

	for count, prompt in ipairs(_G.PROMPT_LIBRARY_LIST) do
		_G.CC_PROMPT_LIBRARY[prompt.description] = prompt
	end

	return _G.CC_PROMPT_LIBRARY
end
