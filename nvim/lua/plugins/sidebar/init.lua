return {

	"sidebar-nvim/sidebar.nvim",

	config = function()
		local default_opts = require("sidebar-nvim.components.loclist").DEFAULT_OPTIONS
		local opts = {
			group_icon = { closed = "", opened = "" },
			show_empty_groups = false,
			groups_initially_closed = true,
		}

		for k, v in pairs(opts) do
			default_opts[k] = v
		end

		local harpoon_files_section = require("plugins.sidebar.components.harpoon")
		local jump_section = require("plugins.sidebar.components.jump")
		local tmux_section = require("plugins.sidebar.components.tmux")
		local register_section = require("plugins.sidebar.components.registers")

		require("sidebar-nvim").setup({
			section_separator = "",
			section_title_separator = "",
			sections = {
				register_section,
				jump_section,
				harpoon_files_section,
				tmux_section,
				"git",
			},
		})
	end,
}
