local format_buffer = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local marks = {}
	local letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for i = 1, #letters do
		local letter = letters:sub(i, i)
		local markLocation = vim.api.nvim_buf_get_mark(bufnr, letter)
		marks[letter] = markLocation
	end

	vim.lsp.buf.format({
		async = false,
	})

	for i = 1, #letters do
		local letter = letters:sub(i, i)
		local markLocation = marks[letter]
		local linenr = markLocation[1]
		if linenr ~= 0 then
			vim.api.nvim_command("" .. linenr .. "mark " .. letter)
		end
	end
end
return format_buffer
