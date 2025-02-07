local function toggle_focus(
)
	vim.cmd("VimadeToggle")
	require("incline").toggle()
end
vim.keymap.set("n", "<leader>f", toggle_focus, { noremap = true, silent = true })
