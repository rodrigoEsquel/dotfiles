return {
	"moyiz/git-dev.nvim",
	event = "VeryLazy",
	opts = {
		cd_type = "tab",
		opener = function(dir)
			vim.cmd("tabnew")
			vim.cmd("Oil " .. vim.fn.fnameescape(dir))
		end,
	},
	keys = {
		{
			"<leader>go",
			function()
				local repo = vim.fn.input("Repository name / URI: ")
				if repo ~= "" then
					require("git-dev").open(repo)
				end
			end,
			desc = "[G]it [O]pen",
		},
	},
}
