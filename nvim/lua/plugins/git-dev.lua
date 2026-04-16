local open_tab = require("plugins.open-tab")

return {
	"moyiz/git-dev.nvim",
	event = "VeryLazy",
	opts = {
		cd_type = "none",
		opener = function(dir)
			vim.cmd("tcd " .. vim.fn.fnameescape(dir))
			vim.cmd("Oil .")
		end,
	},
	keys = {
		{
			"<leader>go",
			function()
				local input = vim.fn.input("Repository name / URI: ")
				local repository, branch = input:match("^(.-)/tree/(.*)$")
				if input and input ~= "" then
					open_tab(input, function()
						if branch then
							require("git-dev").open(repository, { branch = branch }, {})
						else
							require("git-dev").open(input)
						end
					end)
				end
			end,
			desc = "[G]it [O]pen",
		},
	},
}
