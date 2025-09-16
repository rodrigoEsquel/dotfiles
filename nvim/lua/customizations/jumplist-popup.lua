-- lua/customizations/jumplist-popup.lua
local M = {}
local popup_win = nil
local popup_timer = nil

-- Helper: add highlight safely
local function add_hl(bufnr, ns, hl_group, line, start_col, end_col)
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_add_highlight(bufnr, ns, hl_group, line, start_col, end_col)
	end
end

-- Show jumplist popup
function M.show_jumplist(opts)
	opts = vim.tbl_extend("force", { reverse = true, timeout = 1200 }, opts or {})

	-- Close previous popup & timer
	if popup_win and vim.api.nvim_win_is_valid(popup_win) then
		vim.api.nvim_win_close(popup_win, true)
		popup_win = nil
	end
	if popup_timer then
		popup_timer:stop()
		popup_timer:close()
		popup_timer = nil
	end

	local jumplist, idx = unpack(vim.fn.getjumplist())
	if not jumplist or #jumplist == 0 then
		return
	end

	-- Current jump index (1-based)
	local current_index = idx
	if current_index < 1 then
		current_index = 1
	elseif current_index > #jumplist then
		current_index = #jumplist
	end

	-- Build display lines and meta table
	local lines, meta = {}, {}
	local function line_for_jump(j)
		local filename = vim.fn.fnamemodify(vim.fn.bufname(j.bufnr), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local snippet = ""
		pcall(function()
			local ln = vim.api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, false)[1]
			if ln then
				snippet = vim.trim(ln:gsub("%s+", " "))
			end
		end)
		return filename, j.lnum, snippet
	end

	if opts.reverse then
		for i = #jumplist, 1, -1 do
			local filename, lnum, snippet = line_for_jump(jumplist[i])
			table.insert(lines, string.format("%s:%d — %s", filename, lnum, snippet))
			table.insert(meta, i)
		end
	else
		for i = 1, #jumplist do
			local filename, lnum, snippet = line_for_jump(jumplist[i])
			table.insert(lines, string.format("%s:%d — %s", filename, lnum, snippet))
			table.insert(meta, i)
		end
	end

	-- Determine popup line to highlight (fix off-by-one)
	local highlight_line = 1
	for i, orig in ipairs(meta) do
		if orig == current_index then
			highlight_line = i - 1
			break
		end
	end

	-- if highlight_line is an invalid number, default to 1
	if highlight_line < 1 or highlight_line > #lines then
		highlight_line = 1
	end

	-- Create buffer
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
	vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
	vim.api.nvim_buf_set_option(bufnr, "filetype", "jumplist-popup")
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

	-- Open floating window
	local width = 0
	for _, l in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(l))
	end
	local height = math.min(#lines, 10)

	local win_opts = {
		relative = "cursor",
		row = 1,
		col = 1,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		focusable = false,
		noautocmd = true,
	}
	popup_win = vim.api.nvim_open_win(bufnr, false, win_opts)
	pcall(vim.api.nvim_win_set_option, popup_win, "winblend", 10)

	local ns = vim.api.nvim_create_namespace("jumplist_popup_ns")

	-- Highlight current jump line (0-based)
	add_hl(bufnr, ns, "Search", highlight_line - 1, 0, -1)

	-- Highlight filename, line number, and snippet (Tree-sitter optional)
	for i, j_idx in ipairs(meta) do
		local line = i - 1
		local j = jumplist[j_idx]
		local filename = vim.fn.fnamemodify(vim.fn.bufname(j.bufnr), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local fname_len = #filename

		-- Filename
		add_hl(bufnr, ns, "lualine_b_normal", line, 0, fname_len)
		-- Line number
		add_hl(bufnr, ns, "Number", line, fname_len, fname_len + 1)

		-- Optional Tree-sitter highlight for snippet
		local snippet_start = fname_len + 4 -- ":d — "
		local ok, parser = pcall(vim.treesitter.get_parser, j.bufnr)
		if ok and parser then
			local tree = parser:parse()[1]
			if tree then
				local root = tree:root()
				for node, _ in root:iter_children() do
					if node:type() == "identifier" then
						local srow, scol, erow, ecol = node:range()
						if srow == j.lnum - 1 then
							add_hl(bufnr, ns, "Identifier", line, snippet_start + scol, snippet_start + ecol)
						end
					end
				end
			end
		end
	end

	-- Close after timeout
	popup_timer = vim.loop.new_timer()
	popup_timer:start(opts.timeout, 0, function()
		vim.schedule(function()
			if popup_win and vim.api.nvim_win_is_valid(popup_win) then
				vim.api.nvim_win_close(popup_win, true)
			end
			popup_win = nil
			if popup_timer then
				popup_timer:stop()
				popup_timer:close()
				popup_timer = nil
			end
		end)
	end)
end

return M
