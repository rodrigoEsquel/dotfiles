-- Smart hover: DAP if debugging, LSP if available, fallback to default K
vim.api.nvim_set_keymap("n", "K", "", {
	callback = function()
		local ok_dap, dap = pcall(require, "dap")
		if ok_dap and dap.session() ~= nil then
			local ok_widgets, widgets = pcall(require, "dap.ui.widgets")
			if ok_widgets then
				widgets.hover()
			end
			return
		end

		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
		if #clients > 0 then
			vim.lsp.buf.hover()
			return
		end

		vim.cmd("normal! K")
	end,
	noremap = true,
	silent = true,
})
