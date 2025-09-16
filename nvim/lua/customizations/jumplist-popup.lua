-- lua/customizations/jumplist-popup.lua
local M = {}
local popup_win = nil
local popup_timer = nil

function M.show_jumplist(opts)
	opts = vim.tbl_extend("force", { reverse = true, timeout = 1200 }, opts or {})

	-- close previous popup if it exists
	if popup_win and vim.api.nvim_win_is_valid(popup_win) then
		vim.api.nvim_win_close(popup_win, true)
		popup_win = nil
	end
	-- cancel previous timer
	if popup_timer then
		popup_timer:stop()
		popup_timer:close()
		popup_timer = nil
	end

	local jumplist, idx = unpack(vim.fn.getjumplist())
	if not jumplist or #jumplist == 0 then
		return
	end

	local cur_buf = vim.api.nvim_get_current_buf()
	local cur_row = vim.api.nvim_win_get_cursor(0)[1]

	-- detect current jump
	local current_index
	for i, j in ipairs(jumplist) do
		if j.bufnr == cur_buf and j.lnum == cur_row then
			current_index = i
			break
		end
	end
	if not current_index then
		current_index = (idx > 0 and idx or 1)
	end

	-- build display lines
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
				snippet = " — " .. vim.trim(ln:gsub("%s+", " "))
			end
		end)
		return string.format("%s:%d%s", filename, j.lnum, snippet)
	end

	if opts.reverse then
		for i = #jumplist, 1, -1 do
			table.insert(lines, line_for_jump(jumplist[i]))
			table.insert(meta, i)
		end
	else
		for i = 1, #jumplist do
			table.insert(lines, line_for_jump(jumplist[i]))
			table.insert(meta, i)
		end
	end

	-- find highlight line
	local highlight_line = 1
	for i, orig in ipairs(meta) do
		if orig == current_index then
			highlight_line = i
			break
		end
	end

	-- create buffer
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
	vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
	vim.api.nvim_buf_set_option(bufnr, "filetype", "jumplist-popup")
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(bufnr, "modifiable", false)

	-- open window
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

	-- highlight current jump
	local ns = vim.api.nvim_create_namespace("jumplist_popup_ns")
	vim.api.nvim_buf_add_highlight(bufnr, ns, "Search", highlight_line - 1, 0, -1)

	-- start new timer (libuv handle)
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
