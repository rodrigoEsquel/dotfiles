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
				local input = vim.fn.input("Repository name / URI: ")
				local repository, branch = input:match("^(.-)/tree/(.*)$")
				if input then
					if branch then
						require("git-dev").open(repository, { branch = branch }, {})
					else
						require("git-dev").open(input)
					end
				end
			end,
			desc = "[G]it [O]pen",
		},
	},
}
