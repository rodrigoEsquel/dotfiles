return {
	"sindrets/diffview.nvim",
	event = { "BufEnter" },
	keys = {
		{
			"<leader>gq",
			":DiffviewClose<cr>:bdelete gitsigns<tab><cr>",
			{ silent = true, desc = "[G]it diff [Q]uit" },
		},
		{
			"<leader>gw",
			":DiffviewFileHistory % -G<c-r><c-w><CR>",
			{ noremap = true, desc = "[G]it [W]ord file history" },
		},
		{
			"<leader>gD",
			":DiffviewOpen origin/HEAD<CR>",
			{ noremap = true, desc = "[G]it open [D]iff " },
		},
		{
			"<leader>gh",
			":DiffviewFileHistory %<CR>",
			{ noremap = true, desc = "[G]it [F]ile history" },
		},
		{
			"<leader>gH",
			":DiffviewFileHistory<CR>",
			{ noremap = true, desc = "[G]it [H]istory" },
		},
	},
}
