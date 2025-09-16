-- lua/customizations/jumplist-popup.lua
local M = {}

-- options: reverse = true shows newest jumps at top; timeout in ms
function M.show_jumplist(opts)
	opts = vim.tbl_extend("force", { reverse = true, timeout = 1200 }, opts or {})

	local jumplist, idx = unpack(vim.fn.getjumplist()) -- returns {list, idx}
	if not jumplist or #jumplist == 0 then
		return
	end

	local cur_buf = vim.api.nvim_get_current_buf()
	local cur_row = vim.api.nvim_win_get_cursor(0)[1]

	-- try to find the current jump by matching buffer & line (most robust)
	local current_index
	for i, j in ipairs(jumplist) do
		if j.bufnr == cur_buf and j.lnum == cur_row then
			current_index = i
			break
		end
	end
	-- fallback to idx if we didn't find a match (idx may be 0/1 based depending on state)
	if not current_index then
		if type(idx) == "number" and idx >= 1 and idx <= #jumplist then
			current_index = idx
		else
			current_index = 1
		end
	end

	-- build display lines (we keep meta so we can compute highlight position)
	local lines = {}
	local meta = {} -- meta[i] = original index in jumplist
	if opts.reverse then
		for i = #jumplist, 1, -1 do
			local j = jumplist[i]
			local filename = vim.fn.fnamemodify(vim.fn.bufname(j.bufnr), ":t")
			if filename == "" then
				filename = "[No Name]"
			end
			local snippet = ""
			pcall(function()
				local ln = vim.api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, false)[1]
				if ln then
					snippet = " — " .. vim.trim(ln:gsub("%s+", " "))
				end
			end)
			table.insert(lines, string.format("%s:%d%s", filename, j.lnum, snippet))
			table.insert(meta, i)
		end
	else
		for i = 1, #jumplist do
			local j = jumplist[i]
			local filename = vim.fn.fnamemodify(vim.fn.bufname(j.bufnr), ":t")
			if filename == "" then
				filename = "[No Name]"
			end
			local snippet = ""
			pcall(function()
				local ln = vim.api.nvim_buf_get_lines(j.bufnr, j.lnum - 1, j.lnum, false)[1]
				if ln then
					snippet = " — " .. vim.trim(ln:gsub("%s+", " "))
				end
			end)
			table.insert(lines, string.format("%s:%d%s", filename, j.lnum, snippet))
			table.insert(meta, i)
		end
	end

	-- figure which line to highlight in the popup (where meta[line] == current_index)
	local highlight_line = nil
	for i, orig_idx in ipairs(meta) do
		if orig_idx == current_index then
			highlight_line = i
			break
		end
	end
	if not highlight_line then
		highlight_line = 1
	end

	-- create buffer + window
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

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
	}
	local win_id = vim.api.nvim_open_win(bufnr, false, win_opts)
	pcall(vim.api.nvim_win_set_option, win_id, "winblend", 10)

	-- highlight current line
	local ns = vim.api.nvim_create_namespace("jumplist_popup_ns")
	pcall(vim.api.nvim_buf_add_highlight, bufnr, ns, "Search", highlight_line - 1, 0, -1)

	-- close helper
	local function close()
		if vim.api.nvim_win_is_valid(win_id) then
			pcall(vim.api.nvim_win_close, win_id, true)
		end
		-- try to remove the augroup (safe)
		pcall(vim.api.nvim_del_augroup_by_name, "JumplistPopup_" .. tostring(win_id))
	end

	-- autocmd to close on movement / buffer leave etc.
	local augname = "JumplistPopup_" .. tostring(win_id)
	pcall(vim.api.nvim_create_augroup, augname, { clear = true })
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufHidden", "BufLeave", "WinClosed", "WinLeave" }, {
		group = augname,
		callback = function()
			close()
		end,
	})

	-- also close after timeout
	vim.defer_fn(close, opts.timeout)
end

return M
