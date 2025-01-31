vim.api.nvim_set_keymap("n", "K", "", {
	callback = function()
		-- Check if DAP is active
		local dap = require("dap")
		if dap.session() ~= nil then
			-- Call dap.ui.widgets.hover()
			require("dap.ui.widgets").hover()
			-- require("dapui").eval()
			return
		end

		-- Check if LSP is active
		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
		if #clients > 0 then
			-- Call LSP hover
			vim.lsp.buf.hover()
			return
		end

		-- Fallback to default "K" behavior
		vim.cmd("normal! K")
	end,
	noremap = true,
	silent = true,
})
