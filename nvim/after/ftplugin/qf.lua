local function delete_qf_items(start_idx, end_idx)
	-- Get the current quickfix list
	local qf_list = vim.fn.getqflist()

	-- Remove the items in the range
	for i = end_idx, start_idx, -1 do
		table.remove(qf_list, i)
	end

	-- Set the modified quickfix list
	vim.fn.setqflist(qf_list)

	-- Move cursor to the next item after deletion
	vim.cmd(string.format('execute "%d"', start_idx))
end

-- Set up the keymaps for quickfix window only
-- For single line deletion with dd
vim.keymap.set('n', 'dd', function()
	local current_line = vim.fn.line('.')
	delete_qf_items(current_line, current_line)
end, { buffer = true })

-- For visual line selection deletion
vim.keymap.set('v', 'd', function()
	local start_line = vim.fn.line('v')
	local end_line = vim.fn.line('.')
	-- Ensure start_line is smaller than end_line
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	delete_qf_items(start_line, end_line)
	vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
end, { buffer = true })
