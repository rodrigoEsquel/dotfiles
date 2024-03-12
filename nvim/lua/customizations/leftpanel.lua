vim.keymap.set(
	"n",
	"<leader>dd",
	"<cmd>TroubleToggle workspace_diagnostics<cr>",
	{ desc = "Toggle [D]iagnostics sidebar" }
)
vim.keymap.set("n", "<leader>gg", function()
	vim.cmd("vert to Git ")
end, { desc = "Toggle [G]it sidebar" })
