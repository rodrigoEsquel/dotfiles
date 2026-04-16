-- Native undotree (0.12+)
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Toggle [U]ndotree sidebar" })

return {}
