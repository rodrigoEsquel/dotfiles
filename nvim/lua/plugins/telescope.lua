return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		require("telescope.pickers.layout_strategies").horizontal_merged = function(
			picker,
			max_columns,
			max_lines,
			layout_config
		)
			local layout =
				require("telescope.pickers.layout_strategies").horizontal(picker, max_columns, max_lines, layout_config)

			layout.prompt.title = ""
			layout.prompt.borderchars = { "▄", "█", "█", "█", "▄", "▄", "█", "█" }

			layout.results.title = ""
			layout.results.borderchars = { "▄", "█", "█", "█", "▄", "▄", "█", "█" }
			layout.results.line = layout.results.line - 1
			layout.results.height = layout.results.height + 1

			if layout.preview then
				layout.preview.title = ""
				layout.preview.borderchars = { "▄", "▌", "█", "▐", "▗", "▖", "▌", "▐" }
			end

			return layout
		end

		require("telescope").setup({

			defaults = {
				file_ignore_patterns = {
					".git/",
					"node_modules/",
				},
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",
				results_title = false,
				layout_strategy = "horizontal_merged",
				prompt_title = false,
				dynamic_preview_title = true,
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				initial_mode = "insert",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						height = { padding = 2 },
						preview_width = 0.7,
						width = { padding = 5 },
						prompt_position = "top",
					},
				},
				mappings = {
					i = {
						["<C-j>"] = require("telescope.actions").move_selection_next,
						["<C-k>"] = require("telescope.actions").move_selection_previous,
					},
				},

				path_display = { "smart" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(require("telescope").load_extension, "fzf")
		-- pcall(require("telescope").load_extension, "macros")

		-- See `:help telescope.builtin`
		vim.keymap.set(
			"n",
			"<leader>?",
			require("telescope.builtin").oldfiles,
			{ desc = "[?] [S]earch recently opened files" }
		)

		-- vim.keymap.set("n", "<leader><space>", function()
		-- 	require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
		-- 		previewer = false,
		-- 		borderchars = {
		-- 			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
		-- 			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
		-- 			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		-- 		},
		-- 	}))
		-- end, { desc = "[ ] [S]earch existing buffers" })

		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require("telescope.builtin").current_buffer_fuzzy_find()
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>s?", require("telescope.builtin").help_tags, { desc = "[S]earch help[?]" })
		vim.keymap.set(
			"n",
			"<leader>sw",
			require("telescope.builtin").grep_string,
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sh", ":Telescope harpoon marks<CR>", { desc = "[S]earch [H]arpoon marks" })
		-- vim.keymap.set("n", "<leader>sm", ":Telescope macros<CR>", { desc = "[S]earch [M]acros" })
		vim.keymap.set("n", "<leader>ss", ":Telescope git_status<CR>", { desc = "[S]earch git [S]tatus" })
		vim.keymap.set("n", "<leader>sc", ":Telescope git_commits<CR>", { desc = "[S]earch git [C]ommits" })
		vim.keymap.set("n", "<leader>sb", ":Telescope git_branches<CR>", { desc = "[S]earch git [B]ranches" })
		vim.keymap.set("n", "<leader>s<space>", ":Telescope resume<CR>", { desc = "Resume [S]earch" })

		local colors = require("onedark.palette").deep
		local TelescopeColor = {
			TelescopeMatching = { fg = colors.blue },
			TelescopeSelection = { fg = colors.fg, bg = colors.bg1, bold = true },
			TelescopePromptPrefix = { bg = colors.bg0 },
			TelescopePromptTitle = { bg = colors.purple, fg = colors.bg0 },
			TelescopePromptNormal = { bg = colors.grey },
			TelescopePromptBorder = { bg = colors.bg0, fg = colors.grey },

			TelescopeResultsTitle = { fg = colors.bg3 },
			TelescopeResultsNormal = { bg = colors.bg3 },
			TelescopeResultsBorder = { bg = colors.grey, fg = colors.bg3 },

			TelescopePreviewTitle = { bg = colors.green, fg = colors.black },
			TelescopePreviewNormal = { bg = colors.black },
			TelescopePreviewBorder = { bg = colors.bg0, fg = colors.black },
		}

		for hl, col in pairs(TelescopeColor) do
			vim.api.nvim_set_hl(0, hl, col)
		end
	end,
}
