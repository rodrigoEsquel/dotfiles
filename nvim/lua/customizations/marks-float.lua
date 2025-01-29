local highlighter = vim.treesitter.highlighter

local M = {
	marks_win = nil,
	marks_buf = nil,
	top_marks_win = nil,
	top_marks_buf = nil,
	bottom_marks_win = nil,
	bottom_marks_buf = nil,
	last_render_time = 0,
	render_debounce_ms = 300,
	config = {
		marks = {
			-- Lowercase letters (highest priority)
			{
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
			},

			-- Other special marks
			{
				-- "'",
			},
		},
		excluded_filetypes = {
			"dap-repl",
			"dapui_breakpoints",
			"dapui_console",
			"dapui_scopes",
			"dapui_stacks",
			"dapui_watches",
			"dashboard",
			"diff",
			"fugitive",
			"git",
			"gitcommit",
			"harpoon",
			"help",
			"help",
			"neo-tree",
			"neotest-output-panel",
			"neotest-summary",
			"qf",
			"spectre_panel",
			"terminal-split",
			"terminal-vsplit",
			"toggleterm",
			"trouble",
			"undotree",
		},
	},
}

-- Create namespaces for highlights
local mark_ns_top = vim.api.nvim_create_namespace("MarksPlugin_MarkName_Top")
local content_ns_top = vim.api.nvim_create_namespace("MarksPlugin_Content_Top")
local mark_ns_bottom = vim.api.nvim_create_namespace("MarksPlugin_MarkName_Bottom")
local content_ns_bottom = vim.api.nvim_create_namespace("MarksPlugin_Content_Bottom")

local function copy_option(name, from_buf, to_buf)
	--- @cast name any
	local current = vim.bo[from_buf][name]
	-- Only set when necessary to avoid OptionSet events
	if current ~= vim.bo[to_buf][name] then
		vim.bo[to_buf][name] = current
	end
end

local function highlight_marks(buf, bufnr, marks, content_ns, padding_width)
	vim.api.nvim_buf_clear_namespace(bufnr, content_ns, 0, -1)

	local buf_highlighter = highlighter.active[buf]

	copy_option("tabstop", buf, bufnr)

	if not buf_highlighter then
		copy_option("filetype", buf, bufnr)
		return
	end

	local parser = buf_highlighter.tree

	parser:for_each_tree(function(tstree, ltree)
		local buf_query = buf_highlighter:get_query(ltree:lang())
		local query = buf_query:query()
		if not query then
			return
		end

		local p = 0
		local offset = 0
		for _, context in ipairs(marks) do
			local start_row, end_row = context.line_nr - 1, context.line_nr - 1
			local line_start = #context.name + padding_width - 2

			for capture, node, metadata in query:iter_captures(tstree:root(), buf, start_row, end_row + 1) do
				local range = vim.treesitter.get_range(node, buf, metadata[capture])
				local nsrow, nscol, nerow, necol = range[1], range[2], range[4], range[5]

				if nerow > end_row or (nerow == end_row and necol > #context.content) then
					break
				end

				if nsrow >= start_row then
					local msrow = offset + (nsrow - start_row)
					local merow = offset + (nerow - start_row)

					-- Adjust column offsets to account for line_start
					local adj_nscol = nscol + line_start
					local adj_necol = math.min(necol + line_start, #context.content + line_start)

					local hl = buf_query.hl_cache[capture]
					local priority = tonumber(metadata.priority) or
					vim.highlight.priorities.treesitter

					vim.api.nvim_buf_set_extmark(bufnr, content_ns, msrow, adj_nscol, {
						end_row = merow,
						end_col = adj_necol,
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

local function create_marks_window(bufnr, marks, position, padding_width)
	if #marks == 0 then
		return nil, nil
	end

	-- Create buffer for floating window
	local buf = vim.api.nvim_create_buf(false, true)

	-- Prepare content for floating window
	local content = {}
	for _, mark in ipairs(marks) do
		table.insert(
			content,
			string.format(
				"%s%s%s%s",
				string.rep(" ", math.floor((padding_width - 1) / 2)),
				mark.name,
				string.rep(" ", math.ceil((padding_width - 1) / 2)),
				mark.content
			)
		)
	end

	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	-- Get current window width
	local win_width = vim.api.nvim_win_get_width(0)

	local opts = {
		relative = "win",
		width = win_width,
		height = #marks,
		row = position == "top" and 0 or (vim.api.nvim_win_get_height(0) - #marks --[[ -1 if the statusline is actiive ]]
		),
		col = 0, -- Left side of the window
		style = "minimal",
		focusable = false,
		noautocmd = true,
		zindex = 50, -- Ensure it's above other windows
	}

	-- Create floating window
	local win = vim.api.nvim_open_win(buf, false, opts)

	-- Add highlights
	local mark_ns = position == "top" and mark_ns_top or mark_ns_bottom
	local content_ns = position == "top" and content_ns_top or content_ns_bottom
	for i, mark in ipairs(marks) do
		-- Highlight mark name
		local line_start = #mark.name + padding_width - 2
		vim.api.nvim_buf_set_extmark(buf, mark_ns, i - 1, 0, {
			end_col = line_start,
			hl_group = "MarkSignHL",
		})

		-- Highlight content
		highlight_marks(bufnr, buf, marks, content_ns, padding_width + 1)
	end

	return win, buf
end

function M.show_marks()
	for _, filetype in ipairs(M.config.excluded_filetypes) do
		if vim.bo.filetype == filetype then
			return
		end
	end

	local current_time = vim.loop.now()
	if current_time - M.last_render_time < M.render_debounce_ms then
		return
	end

	-- Update last render time
	M.last_render_time = current_time

	-- Close existing marks windows if they exist
	if M.top_marks_win and vim.api.nvim_win_is_valid(M.top_marks_win) then
		vim.api.nvim_win_close(M.top_marks_win, true)
	end
	if M.bottom_marks_win and vim.api.nvim_win_is_valid(M.bottom_marks_win) then
		vim.api.nvim_win_close(M.bottom_marks_win, true)
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

	-- Collect marks
	local marks = {}
	local processed_lines = {}

	-- Iterate through mark type groups
	for priority, group in ipairs(M.config.marks) do
		for _, mark in ipairs(group) do
			local mark_pos = vim.fn.getpos("'" .. mark)
			local line_nr = mark_pos[2]

			-- Check if mark is valid and outside visible window
			if line_nr > 0 and (line_nr < win_first_line or line_nr > win_last_line) then
				local line = vim.fn.getline(line_nr)

				-- Only add if the line hasn't been processed by higher priority marks
				if not processed_lines[line_nr] then
					table.insert(marks, {
						name = mark,
						line_nr = line_nr,
						content = line,
						priority = priority,
					})
					processed_lines[line_nr] = true
				end
			end
		end
	end

	-- Sort marks by line number
	table.sort(marks, function(a, b)
		return a.line_nr < b.line_nr
	end)

	-- If no marks, exit
	if #marks == 0 then
		return
	end

	-- Separate marks into top and bottom groups
	local top_marks = {}
	local bottom_marks = {}
	for _, mark in ipairs(marks) do
		if mark.line_nr < win_first_line then
			table.insert(top_marks, mark)
		else
			table.insert(bottom_marks, mark)
		end
	end

	-- Create windows
	if #top_marks > 0 then
		M.top_marks_win, M.top_marks_buf = create_marks_window(bufnr, top_marks, "top", padding_width)
	end
	if #bottom_marks > 0 then
		M.bottom_marks_win, M.bottom_marks_buf = create_marks_window(bufnr, bottom_marks, "bottom", padding_width)
	end
end

-- Create command to trigger marks display
vim.api.nvim_create_user_command("ShowMarks", M.show_marks, {})

local events = {
	"CursorMoved",
	-- "WinScrolled",
	-- "BufEnter",
	-- "WinEnter",
	-- "VimResized",
	-- "DiagnosticChanged",
	-- "OptionSet",
}

for _, event in ipairs(events) do
	vim.api.nvim_create_autocmd(event, {
		callback = M.show_marks,
		group = vim.api.nvim_create_augroup("ShowMarksAutoCmd", { clear = true }),
	})
end

return M
