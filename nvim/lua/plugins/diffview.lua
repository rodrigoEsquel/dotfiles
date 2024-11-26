local function close_diffview_and_delete_gitsigns_buffers()
	-- Close Diffview
	vim.cmd("DiffviewClose")

	-- Get a list of all buffers
	local buffers = vim.api.nvim_list_bufs()
	-- Loop through each buffer
	for _, buf in ipairs(buffers) do
		local bufname = vim.api.nvim_buf_get_name(buf)
		-- Check if the buffer name contains 'gitsigns'
		if string.match(bufname, "gitsigns") then
			-- Delete the buffer if it matches
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

return {
	"sindrets/diffview.nvim",
	event = { "BufEnter" },
	setup = function() end,
	keys = {
		{
			"<leader>gq",
			close_diffview_and_delete_gitsigns_buffers,
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
