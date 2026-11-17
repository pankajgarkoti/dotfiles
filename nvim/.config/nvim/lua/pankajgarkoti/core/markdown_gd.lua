-- Filtered "go to definition" for markdown.
-- When the LSP returns multiple definition candidates for a link, keep only
-- those whose filename (sans extension) or first/top-level heading matches
-- the link under the cursor. Falls back to the unfiltered list when nothing
-- matches.
local M = {}

-- Extract the link text and destination under the cursor via treesitter
-- (markdown_inline injection). Returns (text, dest), either may be nil.
local function link_under_cursor()
	local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = false })
	if not ok or not node then
		return nil, nil
	end

	local containers = {
		inline_link = true,
		shortcut_link = true,
		full_reference_link = true,
		collapsed_reference_link = true,
		wiki_link = true,
		link_reference_definition = true,
	}

	while node and not containers[node:type()] do
		node = node:parent()
	end
	if not node then
		return nil, nil
	end

	local text, dest
	for child in node:iter_children() do
		local t = child:type()
		if t == "link_text" then
			text = vim.treesitter.get_node_text(child, 0)
		elseif t == "link_destination" then
			dest = vim.treesitter.get_node_text(child, 0)
		end
	end
	return text, dest
end

-- First heading (any level, first one encountered) of a file, or nil.
local function first_heading(fname)
	local f = io.open(fname, "r")
	if not f then
		return nil
	end
	local count = 0
	for line in f:lines() do
		count = count + 1
		local h = line:match("^#+%s+(.+)")
		if h then
			f:close()
			return vim.trim(h)
		end
		if count > 100 then
			break
		end
	end
	f:close()
	return nil
end

local function norm(s)
	if not s then
		return nil
	end
	-- lowercase and treat dashes/underscores as spaces so that
	-- "Target Note" matches "target-note.md" / "target_note.md"
	local out = vim.trim(s):lower():gsub("[-_]+", " ")
	return out
end

local function loc_uri(loc)
	return loc.uri or loc.targetUri
end

local function filter_locations(locs)
	local text, dest = link_under_cursor()
	local queries = {}
	if text then
		table.insert(queries, norm(text))
	end
	if dest then
		-- strip anchors like file.md#section and compare by basename
		local path = dest:gsub("#.*$", "")
		if path ~= "" then
			table.insert(queries, norm(vim.fn.fnamemodify(path, ":t:r")))
		end
	end
	if #queries == 0 then
		return locs
	end

	local filtered = {}
	for _, loc in ipairs(locs) do
		local fname = vim.uri_to_fname(loc_uri(loc))
		local base = norm(vim.fn.fnamemodify(fname, ":t:r"))
		local keep = false
		for _, q in ipairs(queries) do
			if base == q then
				keep = true
				break
			end
		end
		if not keep then
			local heading = norm(first_heading(fname))
			if heading then
				for _, q in ipairs(queries) do
					if heading == q then
						keep = true
						break
					end
				end
			end
		end
		if keep then
			table.insert(filtered, loc)
		end
	end

	-- Never filter down to nothing; fall back to the full list.
	if #filtered > 0 then
		return filtered
	end
	return locs
end

-- Marksman returns one candidate per top-level heading in the target file.
-- Collapse candidates that live in the same file down to the earliest
-- (highest) one.
local function collapse_per_file(locs)
	local best = {} -- uri -> loc
	local order = {} -- keep stable output ordering
	for _, loc in ipairs(locs) do
		local uri = loc_uri(loc)
		local range = loc.range or loc.targetSelectionRange
		local line = range and range.start.line or 0
		local current = best[uri]
		if not current then
			best[uri] = loc
			table.insert(order, uri)
		else
			local crange = current.range or current.targetSelectionRange
			if line < (crange and crange.start.line or 0) then
				best[uri] = loc
			end
		end
	end
	local out = {}
	for _, uri in ipairs(order) do
		table.insert(out, best[uri])
	end
	return out
end

function M.definition()
	local bufnr = vim.api.nvim_get_current_buf()
	local params = vim.lsp.util.make_position_params(0, "utf-8")

	vim.lsp.buf_request_all(bufnr, "textDocument/definition", params, function(results)
		local locs = {}
		local seen = {}
		for _, res in pairs(results) do
			local result = res.result
			if result then
				if result.uri or result.targetUri then
					result = { result }
				end
				for _, loc in ipairs(result) do
					local range = loc.range or loc.targetSelectionRange
					local key = loc_uri(loc)
						.. ":"
						.. (range and range.start.line or 0)
						.. ":"
						.. (range and range.start.character or 0)
					if not seen[key] then
						seen[key] = true
						table.insert(locs, loc)
					end
				end
			end
		end

		if #locs == 0 then
			vim.notify("No definition found", vim.log.levels.INFO)
			return
		end

		locs = collapse_per_file(filter_locations(locs))

		if #locs == 1 then
			vim.lsp.util.show_document(locs[1], "utf-8", { focus = true })
		else
			vim.fn.setqflist({}, " ", {
				title = "LSP definitions (filtered)",
				items = vim.lsp.util.locations_to_items(locs, "utf-8"),
			})
			vim.cmd("botright copen")
		end
	end)
end

return M
