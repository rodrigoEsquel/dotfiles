return {
	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	-- See `:help lualine.txt`
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"meuter/lualine-so-fancy.nvim",
	},
	opts = function()
		local function filepath()
			local str = vim.fn.expand("%:.")
			local lastSlashIndex = str:match(".*/()")
			if lastSlashIndex then
				return str:sub(1, lastSlashIndex - 1)
			else
				return str:gsub("/$", "")
			end
		end

		local function pin()
			local bufnr = vim.api.nvim_get_current_buf()
			if GlobalState.marked_buffers[bufnr] then
				return "󰤱"
			else
				return ""
			end
		end

		local buffers = require("customizations.lualine-harpoon")

		return {
			options = {
				globalstatus = true,
				theme = "auto",
				component_separators = "",
				section_separators = "" --[[ { left = "", right = "" }, ]],
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
					{ "fancy_cwd", substitute_home = true },
				},
				lualine_x = {
					{ "fancy_macro" },
					{ "fancy_diagnostics" },
					{ "fancy_searchcount" },
				},
				lualine_y = {
					{ "fancy_filetype", ts_icon = "" },
				},
				lualine_z = {
					{ "fancy_lsp_servers" },
				},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {
					{
						"filetype",
						icon_only = true, -- Display only an icon for filetype
					},
					filepath,
				},
				lualine_c = {
					"filename",
					pin,
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					"filename",
					pin,
				},

				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {
				lualine_a = { buffers },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "tabs" },
			},
		}
	end,
}
