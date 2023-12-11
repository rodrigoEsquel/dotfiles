local width = 40
local mode = "normal"
local function closeTab()
	if mode == "normal" then
	elseif mode == "trouble" then
		vim.cmd.TroubleClose()
	elseif mode == "undo" then
		vim.cmd.UndotreeHide()
	elseif mode == "sidebar" then
		require("sidebar-nvim").close()
	else
		vim.cmd("1wincmd c")
	end
end
local function toggle_sidebar()
	closeTab()
	if mode == "sidebar" then
		mode = "normal"
	else
		require("sidebar-nvim").open()
		mode = "sidebar"
	end
end
local function toggle_git()
	closeTab()
	if mode == "git" then
		mode = "normal"
	else
		vim.cmd("vert to Git | vert resize " .. tostring(width))
		mode = "git"
	end
end
local function toggle_undotree()
	closeTab()
	if mode == "undo" then
		mode = "normal"
	else
		vim.cmd.UndotreeShow()
		mode = "undo"
	end
end
local function toggle_trouble()
	closeTab()
	if mode == "trouble" then
		mode = "normal"
	else
		vim.cmd("lua require('trouble').open('workspace_diagnostics')")
		vim.cmd("wincmd H | vert resize " .. tostring(width))
		mode = "trouble"
	end
end

require("sidebar-nvim").setup({ initial_width = width })
vim.g.undotree_SplitWidth = width

vim.keymap.set("n", "<leader>u", toggle_undotree, {desc = "Toggle [U]ndotree sidebar"} )
vim.keymap.set("n", "<leader>dd", toggle_trouble, {desc = "Toggle [D]iagnostics sidebar"} )
vim.keymap.set("n", "<leader>gg", toggle_git, {desc = "Toggle [G]it sidebar"} )
vim.keymap.set("n", "<leader>i", toggle_sidebar, {desc = "Toggle [I]nfo sidebar"})
