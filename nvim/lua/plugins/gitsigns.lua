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
				-- map("n", "<leader>gs", gs.stage_buffer, { desc = "[G]it [S]tage buffer" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "[G]it [S]tage hunk" })
				-- map("v", "<leader>gr", function()
				--   gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				-- end, { desc = "[G]it [R]eset hunk" })
				map("n", "<leader>gu", function()
					gs.undo_stage_hunk({ 1, vim.fn.line("$") })
				end, { desc = "[G]it [U]ndo stage hunk" })
				map("v", "<leader>gu", gs.undo_stage_hunk, { desc = "[G]it [U]ndo stage hunk" })
				-- map("n", "<leader>gr", gs.reset_buffer_index, { desc = "[G]it [R]eset buffer" })
				-- map("v", "<leader>gd", gs.preview_hunk, { desc = "[G]it [P]review hunk" })
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, { desc = "[G]it [B]lame line" })
				map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "[G]it [B]lame toggle" })
				map("n", "<leader>gd", gs.diffthis, { desc = "[G]it [D]iff this" })
				-- map("n", "<leader>gD", function()
				-- 	gs.diffthis("origin/main")
				-- end, { desc = "[G]it [D]iff this to main" })
				-- map('n', '<leader>td', gs.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
				map({ "o", "x" }, "ag", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		})

		vim.keymap.set("n", "<leader>gc", function()
			vim.cmd("Git commit")
		end, { noremap = false, desc = "[G]it [C]ommit" })
		vim.api.nvim_set_keymap("n", "<leader>gp", ":Git pull<CR>", { noremap = false, desc = "[G]it [P]ull" })
	end,
}
