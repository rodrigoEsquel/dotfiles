local open_tab = require("customizations.open-tab")
local input
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
				input = vim.fn.input("Repository name / URI: ")
				local repository, branch = input:match("^(.-)/tree/(.*)$")
				-- check if input exist and is a not empty strng
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
