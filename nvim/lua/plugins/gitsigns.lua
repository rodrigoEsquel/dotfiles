return {
	-- Adds git releated signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signcolumn = false,
			numhl = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })
				-- Actions
				map("n", "<leader>gs", gs.stage_buffer, { desc = "[G]it [S]tage buffer" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[G]it [S]tage hunk" })
				-- map("v", "<leader>gr", function()
				--   gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				-- end, { desc = "[G]it [R]eset hunk" })
				-- map("n", "<leader>gu", gs.undo_stage, { desc = "[G]it [U]ndo stage buffer" })
				-- map("v", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it [U]ndo stage hunk" })
				-- map("n", "<leader>gr", gs.reset_buffer_index, { desc = "[G]it [R]eset buffer" })
				-- map("v", "<leader>gd", gs.preview_hunk, { desc = "[G]it [P]review hunk" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "[G]it [B]lame line" })
				map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "[G]it [B]lame toggle" })
				map("n", "<leader>gd", gs.diffthis, { desc = "[G]it [D]iff this" })
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, { desc = "[G]it [D]iff this ~" })
				-- map('n', '<leader>td', gs.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		})

		local function create_centered_floating_window()
			local width = math.min(80,math.floor(vim.o.columns * 0.8))
			local height = math.floor(vim.o.lines * 0.8)

			local opts = {
				relative = "editor",
				width = width,
				height = height,
				col = math.floor((vim.o.columns - width) / 2),
				row = math.floor((vim.o.lines - height) / 2) - 1,
				style = "minimal",
			}

			local opts_new = {
				relative = opts.relative,
				width = opts.width - 4,
				height = opts.height - 2,
				col = opts.col + 2,
				row = opts.row + 1,
				style = opts.style,
			}

			vim.api.nvim_win_set_config(0, opts_new)
			-- vim.api.nvim_open_win(buf, true, opts)
		end

		vim.keymap.set("n", "<leader>gc", function()
			vim.cmd("Git commit")
			create_centered_floating_window()
		end, { noremap = false, desc = "[G]it [C]ommit" })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>gp",
			":Git push -u origin HEAD<CR>",
			{ noremap = false, desc = "[G]it [P]ush" }
		)
	end,
}
