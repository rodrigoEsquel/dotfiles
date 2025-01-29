local function open_db_ui()
	-- Iterate through existing tabs
	for i = 1, vim.fn.tabpagenr("$") do
		-- Check if the tab has a name containing "db"
		local tabname = vim.fn.fnamemodify(vim.fn.bufname(vim.fn.tabpagebuflist(i)[1]), ":t")
		if string.find(string.lower(tabname), "db") then
			-- If found, switch to that tab
			vim.cmd(i .. "tabnext")
			return
		end
	end

	-- If no db tab exists, create a new tab
	vim.cmd("tabnew")

	-- Optionally, set the tab name (if your Neovim setup supports tab naming)
	vim.cmd("LualineRenameTab db")

	-- Run the BUI command
	vim.cmd("DBUI")
end

vim.keymap.set("n", "<leader>od", open_db_ui, { desc = "[O]pen [D]atabase UI" })

return {

	{
		"tpope/vim-dadbod",
		requires = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			local function db_completion()
				require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
			end

			vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sql",
				},
				command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"sql",
					"mysql",
					"plsql",
				},
				callback = function()
					vim.schedule(db_completion)
				end,
			})
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
}
