return {
	"mickael-menu/zk-nvim",
	config = function()
		require("zk").setup({
			-- can be "telescope", "fzf", "fzf_lua" or "select" (`vim.ui.select`)
			-- it's recommended to use "telescope", "fzf" or "fzf_lua"
			picker = "telescope",

			lsp = {
				-- `config` is passed to `vim.lsp.start_client(config)`
				config = {
					cmd = { "zk", "lsp" },
					name = "zk",
					-- on_attach = ...
					-- etc, see `:h vim.lsp.start_client()`
				},

				-- automatically attach buffers in a zk notebook that match the given filetypes
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			},
		})

		-- Create a new note after asking for its title.
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nn",
			"<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
			{ noremap = true, silent = false, desc = "[N]ew [N]ote" }
		)
		vim.api.nvim_set_keymap(
			"v",
			"<leader>nn",
			":'<,'>ZkNewFromTitleSelection <CR>",
			{ noremap = true, silent = false, desc = "[N]ew [N]ote" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"<leader>nd",
			"<Cmd>ZkNew { dir = 'daily' }<CR>",
			{ noremap = true, silent = false, desc = "[N]ew [D]aily note" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nm",
			"<Cmd>ZkNew { dir = 'meeting', title = vim.fn.input('Title: ') }<CR>",
			{ noremap = true, silent = false, desc = "[N]ew [M]eeting note" }
		)

		-- Open notes.
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nf",
			"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
			{ noremap = true, silent = false, desc = "[N]ote [F]ind" }
		)
		-- Search for the notes matching the current visual selection.
		vim.api.nvim_set_keymap(
			"v",
			"<leader>nf",
			":'<,'>ZkMatch<CR>",
			{ noremap = true, silent = false, desc = "[N]ote [F]ind" }
		)

		-- Open notes associated with the selected tags.
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nt",
			"<Cmd>ZkTags<CR>",
			{ noremap = true, silent = false, desc = "[N]ote find by [T]ag" }
		)
	end,
}
