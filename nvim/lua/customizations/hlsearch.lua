local hlsearch = false

vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		-- print(vim.fn.keytrans(char)) "v" is a workaround until i have a proper keyboard
		local keyIsSearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/", "v" }, vim.fn.keytrans(char))
		if keyIsSearch ~= hlsearch then
			hlsearch = keyIsSearch
			vim.opt.hlsearch = keyIsSearch
		end
	end
end, vim.api.nvim_create_namespace("auto_hlsearch"))
