return {
	-- Autocompletion
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"Exafunction/codeium.nvim",
		"chrisgrieser/cmp_yanky",
		"luckasRanarison/tailwind-tools.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("codeium").setup({})
		local lua_types = require("luasnip.util.types")
		luasnip.config.setup({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = true,
			ext_opts = {
				[lua_types.choiceNode] = {
					active = {
						virt_text = { { "", "error" } },
					},
				},
			},
		})

		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		local kind_icons = {
			Text = "",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰇽",
			Variable = "󰂡",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "■",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰅲",
			Codeium = "󰌵",
		}

		local utils = require("tailwind-tools.utils")
		local formatting = {
			-- default fields order i.e completion word + item.kind + item.kind icons
			fields = { "abbr", "kind", "menu" },
			format = function(entry, item)
				local doc = entry.completion_item.documentation

				if item.kind == "Color" and type(doc) == "string" then
					local _, _, r, g, b = doc:find("rgba?%((%d+), (%d+), (%d+)")
					if r then
						item.kind_hl_group = utils.set_hl_from(r, g, b, "foreground")
					end
				end

				item.menu = entry:get_completion_item().detail
				item.abbr = item.abbr:gsub("^%s*", "")
				if #item.abbr > 50 then
					item.abbr = item.abbr:sub(1, 50)
				end

				local icon = (" " .. kind_icons[item.kind] .. " ")
				item.kind = string.format("%s %s", icon, item.kind or "")

				return item
			end,
		}

		cmp.setup({
			window = {
				completion = {
					scrollbar = false,
					border = "rounded",
				},
				documentation = {
					winhighlight = "Normal:CmpDoc",
					border = "rounded",
				},
			},
			formatting = formatting,
			completion = {
				completeopt = "menu,menuone,preview,noselect",
				autocomplete = {
					cmp.TriggerEvent.TextChanged,
					cmp.TriggerEvent.InsertEnter,
				},
				keyword_length = 0,
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping({
					i = function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end,
				}),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({
							behavior = cmp.SelectBehavior.Insert,
							select = true,
						})
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = {
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "codeium" },
				{ name = "vim-dadbod-completion" },
				{ name = "path" },
				{ name = "buffer" },
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})

		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- vim.keymap.set(
		-- 	"i",
		-- 	"<C-p>",
		-- 	"<Cmd>lua require('cmp').complete({ config = { sources = { { name = 'cmp_yanky' } } } })<CR>",
		-- 	{ desc = "Open completion with yanky registers" }
		-- )

		local color = require("kanagawa.colors").setup({ theme = "wave" }).theme.term
		-- gray
		vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = color[6] })
		-- blue
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = color[5] })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })

		vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = color[17] })
		vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
		vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindVariable" })

		vim.api.nvim_set_hl(0, "CmpItemKindText", { bg = "NONE", fg = color[3] })
		-- pink
		vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = color[5] })
		vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
		-- front
		vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = color[2] })
		vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
	end,
}
