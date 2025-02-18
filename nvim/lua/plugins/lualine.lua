return {

	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	-- See `:help lualine.txt`
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"meuter/lualine-so-fancy.nvim",
	},

	opts = function()
		local winbar = require("customizations.new-winbar")
		local harpoon_buffers = require("customizations.lualine-harpoon")

		return {
			options = {
				globalstatus = true,
				theme = "auto",
				component_separators = "",
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				disabled_filetypes = {
					-- winbar = {
					-- 	"dap-repl",
					-- 	"dapui_breakpoints",
					-- 	"dapui_console",
					-- 	"dapui_scopes",
					-- 	"dapui_stacks",
					-- 	"dapui_watches",
					-- 	"dashboard",
					-- 	"diff",
					-- 	"fugitive",
					-- 	"git",
					-- 	"gitcommit",
					-- 	"harpoon",
					-- 	"help",
					-- 	"neo-tree",
					-- 	"neotest-output-panel",
					-- 	"neotest-summary",
					-- 	"qf",
					-- 	"spectre_panel",
					-- 	"terminal-split",
					-- 	"terminal-vsplit",
					-- 	"toggleterm",
					-- 	"trouble",
					-- 	"undotree",
					-- },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {
					-- { "fancy_diff" },
				},
				lualine_c = {
					-- filepath,
					-- { "fancy_cwd", substitute_home = true },
				},
				lualine_x = {
					-- { "fancy_macro" },
					-- { "fancy_diagnostics" },
					-- { "fancy_searchcount" },
				},
				lualine_y = {
					-- { "fancy_filetype", ts_icon = "" },
					-- { "fancy_lsp_servers" },
				},
				lualine_z = {
					-- "location",
				},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					winbar,
					{ "fancy_diagnostics" },
					{ "fancy_diff" },
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { winbar },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = {
					{ "fancy_mode", width = 3 },
				},
				lualine_b = {
					{ "fancy_branch" },
				},
				lualine_c = {
					harpoon_buffers,
				},
				lualine_x = {
					{ "fancy_macro" },
					{ "overseer" },
				},
				lualine_y = {
					{ "fancy_lsp_servers" },
				},
				lualine_z = { {
					"tabs",
					mode = 2,
				} },
			},
		}
	end,
}
