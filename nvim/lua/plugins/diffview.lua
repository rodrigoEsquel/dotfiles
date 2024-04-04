return {
	"sindrets/diffview.nvim",
	event = { "BufEnter" },
	keys = {
		{
			"<leader>gq",
			":DiffviewClose<cr>:bdelete gitsigns<tab><cr>",
			desc = "[G]it diff [Q]uit",
			silent = true,
		},
		{
			"<leader>gw",
			":DiffviewFileHistory % -G<c-r><c-w><CR>",
			desc = "[G]it [W]ord file history",
			noremap = true,
		},
		{
			"<leader>gD",
			":DiffviewOpen origin/HEAD<CR>",
			desc = "[G]it open [D]iff ",
			noremap = true,
		},
		{
			"<leader>gh",
			":DiffviewFileHistory %<CR>",
			desc = "[G]it [F]ile history",
			noremap = true,
		},
		{
			"<leader>gH",
			":DiffviewFileHistory<CR>",
			desc = "[G]it [H]istory",
			noremap = true,
		},
	},
}
