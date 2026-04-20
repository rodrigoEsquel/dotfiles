-- Native undotree (0.12+)
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.cmd.packadd("nvim.undotree")
	end,
})
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Toggle [U]ndotree sidebar" })

return {}
