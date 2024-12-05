return {

	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	-- See `:help lualine.txt`
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"meuter/lualine-so-fancy.nvim",
	},

	opts = function()
		local function getLastItem()
			local path = vim.fn.expand("%:.")
			local cleanPath = path:gsub("/$", "")
			-- Extract the last part of the path
			local lastItem = cleanPath:match("([^/]+)$")
			if lastItem == nil then
				return ""
			end
			return lastItem
		end

		local function removeLastItem()
			local path = vim.fn.expand("%:.")
			local cleanPath = path:gsub("/$", "")
			-- Extract the path without the last item
			local basePath = cleanPath:match("(.*/)")
			if basePath == nil then
				return ""
			end
			return basePath
		end

		local function filepath()
			local str = vim.fn.expand("%:.")
			local lastSlashIndex = str:match(".*/()")
			if lastSlashIndex then
				-- return str:sub(1, lastSlashIndex - 1)
				return str
			else
				return str:gsub("/$", "")
			end
		end

		local function bufferName()
			local str = vim.fn.expand("%:.")
			local lastSlashIndex = str:match(".*/()")
			if lastSlashIndex then
				return str:sub(1, lastSlashIndex - 1)
			else
				return str:gsub("/$", "")
			end
		end

		local function emptyString()
			return " "
		end

		local harpoon_buffers = require("customizations.lualine-harpoon")
		local winbar = require("customizations.windbar")

		return {
			options = {
				globalstatus = true,
				theme = "auto",
				component_separators = "",
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
				disabled_filetypes = {
					winbar = {
						"dap-repl",
						"dapui_breakpoints",
						"dapui_console",
						"dapui_scopes",
						"dapui_stacks",
						"dapui_watches",
						"dashboard",
						"diff",
						"fugitive",
						"git",
						"gitcommit",
						"harpoon",
						"help",
						"neo-tree",
						"neotest-output-panel",
						"neotest-summary",
						"qf",
						"spectre_panel",
						"terminal-split",
						"terminal-vsplit",
						"toggleterm",
						"trouble",
						"undotree",
					},
				},
			},
			sections = {
				lualine_a = {
					{ "fancy_mode", width = 3 },
				},
				lualine_b = {
					{ "fancy_branch" },
					{ "fancy_diff" },
				},
				lualine_c = {
					-- filepath,
					-- { "fancy_cwd", substitute_home = true },
				},
				lualine_x = {
					{ "fancy_macro" },
					{ "fancy_diagnostics" },
					{ "fancy_searchcount" },
				},
				lualine_y = {
					{ "fancy_filetype", ts_icon = "" },
					{ "fancy_lsp_servers" },
				},
				lualine_z = { "location" },
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { winbar },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { getLastItem },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = { harpoon_buffers },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "tabs" },
			},
		}
	end,
}
