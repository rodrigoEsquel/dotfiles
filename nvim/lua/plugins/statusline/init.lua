return {

	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	-- See `:help lualine.txt`
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"meuter/lualine-so-fancy.nvim",
	},
	config = function(_, opts)
		vim.opt.laststatus = 0
		require("lualine").setup(opts)
		require("lualine").hide({
			place = { "statusline" }, -- The segment this change applies to.
			unhide = false, -- whether to re-enable lualine again/
		})
		vim.api.nvim_set_hl(0, "Statusline", { link = "Normal", bg = "NONE" })
		vim.api.nvim_set_hl(0, "StatuslineNC", { link = "Normal", bg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "NONE", background = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
		local str = " "
		vim.opt.statusline = str
	end,
	opts = function()
		local diagnostics = require("plugins.statusline.diagnostic")
		local winbar = require("plugins.statusline.winbar")
		local harpoon_buffers = require("plugins.statusline.bookmarks")
		local colors = require("kanagawa.colors").setup({ theme = "dragon" }).theme

		return {
			options = {
				globalstatus = true,
				on_colors = function(c)
					c.bg_statusline = "NONE"
				end,
				theme = "kanagawa",
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {
					{ winbar, padding = { left = 1, right = 0 } },
				},
				lualine_c = {
					{ "fancy_diff", color = { bg = "NONE" } },
					{ diagnostics.error_ind, color = { fg = colors.diag.error, bg = "NONE" } },
					{ diagnostics.warn_ind, color = { fg = colors.diag.warning, bg = "NONE" } },
					{ diagnostics.info_ind, color = { fg = colors.diag.info, bg = "NONE" } },
					{ diagnostics.note_ind, color = { fg = colors.diag.hint, bg = "NONE" } },
					{
						function()
							return " "
						end,
						padding = { left = 0, right = 0 },
						color = { fg = colors.ui.bg, bg = "NONE" },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {
					{ winbar, padding = { left = 1, right = 0 } },
				},
				lualine_c = {
					{
						function()
							return " "
						end,
						color = { bg = "NONE" },
					},
				},
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
					{
						function()
							return ""
						end,
						padding = { left = 0, right = 0 },
						color = { fg = "#252535", bg = "NONE" },
					},
				},
				lualine_c = {
					{ harpoon_buffers },
					{
						function()
							return " "
						end,
						color = { fg = "NONE", bg = "NONE" },
					},
				},
				lualine_x = {
					{
						function()
							local reg = vim.v.register
							local reg_display = reg == "" and '"' or reg == "%" and "%%" or reg
							local content = vim.fn.getreg(reg == "" and '"' or reg)
							if content and content ~= "" then
								content = content:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")

								if #content > 20 then
									content = content:sub(1, 17)
									content = content .. "..."
								end

								content = content:gsub("%%", "%%%%") -- This replaces % with %%

								return "[" .. reg_display .. "] " .. content
							else
								return reg_display
							end
						end,
						icon = "󱉨", -- clipboard icon
						color = { fg = "#ff9e64", bg = "NONE" }, -- optional: customize color
					},
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
