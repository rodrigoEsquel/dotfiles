local open_tab = require("customizations.open-tab")

local function open_db_ui()
	open_tab("db", function()
		-- Run the BUI command
		vim.cmd("DBUI")
	end)
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
		keys = {
			{
				"<leader>ds",
				"<Plug>(DBUI_SaveQuery)",
				desc = "[D]atabase [S]ave Query",
			},
		},
	},
}
