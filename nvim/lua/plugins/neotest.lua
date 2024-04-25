return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		{
			"nvim-neotest/neotest-jest",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})
	end,
	-- stylua: ignore
	keys = {
		{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
		{ "<leader>ta", function() require("neotest").run.run(vim.loop.cwd()) end,                          desc = "Run All Test Files" },
		{ "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
		{ "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "Run Last" },
		{ "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
		{ "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
		{ "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
	},
}
