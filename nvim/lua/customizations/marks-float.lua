local highlighter = vim.treesitter.highlighter

local M = {
	marks_win = nil,
	marks_buf = nil,
}


local function copy_option(name, from_buf, to_buf)
	--- @cast name any
	local current = vim.bo[from_buf][name]
	-- Only set when necessary to avoid OptionSet events
	if current ~= vim.bo[to_buf][name] then
		vim.bo[to_buf][name] = current
	end
end

local function highlight_marks(buf, bufnr, marks)
	vim.api.nvim_buf_clear_namespace(bufnr, content_ns, 0, -1)

	local buf_highlighter = highlighter.active[buf]

	copy_option("tabstop", buf, bufnr)

	if not buf_highlighter then
		-- Use standard highlighting when TS highlighting is not available
		copy_option("filetype", buf, bufnr)
		return
	end

	local parser = buf_highlighter.tree

	parser:for_each_tree(function(tstree, ltree)
		local buf_query = buf_highlighter:get_query(ltree:lang())
		-- local query = query.get(ltree:lang(), 'highlights')
		local query = buf_query:query()
		if not query then
			return
		end

		local p = 0
		local offset = 0
		for _, context in ipairs(marks) do
			local start_row, end_row, end_col = context.line_nr, context.line_nr, -1

			for capture, node, metadata in query:iter_captures(tstree:root(), buf, start_row, end_row + 1) do
				local range = vim.treesitter.get_range(node, buf, metadata[capture])
				local nsrow, nscol, nerow, necol = range[1], range[2], range[4], range[5]

				if nerow > end_row or (nerow == end_row and necol > end_col and end_col ~= -1) then
					break
				end

				if nsrow >= start_row then
					local msrow = offset + (nsrow - start_row)
					local merow = offset + (nerow - start_row)

					local hl = buf_query.hl_cache[capture]
					local priority = tonumber(metadata.priority) or vim.highlight.priorities.treesitter

					vim.api.nvim_buf_set_extmark(bufnr, content_ns, msrow, nscol, {
						end_row = merow,
						end_col = necol,
						priority = priority + p,
						hl_group = hl,
					})

					p = p + 1
				end
			end
			offset = offset + 1
		end
	end)
end

function M.show_marks()
	-- Close existing marks window if it exists
	if M.marks_win and vim.api.nvim_win_is_valid(M.marks_win) then
		vim.api.nvim_win_close(M.marks_win, true)
	end

	-- Get current window and buffer details
	local winnr = vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get visible line range in current window
	local win_first_line = vim.fn.line("w0")
	local win_last_line = vim.fn.line("w$")

	-- Determine signcolumn and numbercolumn width
	local signcolumn_width = vim.o.signcolumn == "yes" and 2 or 0
	local numbercolumn_width = vim.o.number and #tostring(vim.fn.line("$")) + 1 or 0
	local padding_width = signcolumn_width + numbercolumn_width

	-- Get all marks from a to z for current buffer
	local marks = {}
	for _, mark in ipairs({
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
	}) do
		local mark_pos = vim.fn.getpos("'" .. mark)
		local line_nr = mark_pos[2]

		-- Only add mark if it's outside current visible window
		if line_nr > 0 and (line_nr < win_first_line or line_nr > win_last_line) then
			local line = vim.fn.getline(line_nr)
			table.insert(marks, {
				name = mark,
				line_nr = line_nr,
				content = line,
			})
		end
	end

	-- Sort marks by line number
	table.sort(marks, function(a, b)
		return a.line_nr < b.line_nr
	end)

	-- If no marks, exit
	if #marks == 0 then
		print("No marks found outside visible window")
		return
	end

	-- Create buffer for floating window
	local buf = vim.api.nvim_create_buf(false, true)

	-- Create namespaces for highlights
	local mark_ns = vim.api.nvim_create_namespace("MarksPlugin_MarkName")
	local content_ns = vim.api.nvim_create_namespace("MarksPlugin_Content")

	-- Prepare content for floating window
	local content = {}
	for _, mark in ipairs(marks) do
		table.insert(
			content,
			string.format(
				"%s%s%s%s",
				string.rep(" ", math.floor(padding_width / 2)),
				mark.name,
				string.rep(" ", math.ceil(padding_width / 2)),
				mark.content
			)
		)
	end

	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	-- Get current window width
	local win_width = vim.api.nvim_win_get_width(0)
	local win_height = #marks

	local opts = {
		relative = "win",
		width = win_width,
		height = win_height,
		row = 0, -- Top of the window
		col = 0, -- Left side of the window
		style = "minimal",
		focusable = false,
		noautocmd = true,
		zindex = 50, -- Ensure it's above other windows
	}

	-- Create floating window
	M.marks_win = vim.api.nvim_open_win(buf, false, opts)
	M.marks_buf = buf

	-- Add highlights using extmarks
	for i, mark in ipairs(marks) do
		-- Highlight content
		local line_start = #mark.name + padding_width - 1
		-- Highlight mark name with CursorLineNr
		vim.api.nvim_buf_set_extmark(buf, mark_ns, i - 1, 0, {
			end_col = line_start,
			hl_group = "CursorLineNr",
		})

		vim.api.nvim_buf_set_extmark(buf, content_ns, i - 1, line_start, {
			end_col = #content[i],
			hl_group = "Normal", -- Using Normal highlight as a fallback
			priority = 100,
		})
	end
end

-- Create command to trigger marks display
vim.api.nvim_create_user_command("ShowMarks", M.show_marks, {})

return M
