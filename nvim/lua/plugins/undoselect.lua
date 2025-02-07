return {
	"SunnyTamang/select-undo.nvim",
	config = function()
		require("select-undo").setup({
			persistent_undo = false, -- Enables persistent undo history
			mapping = false, -- Enables default keybindings
			line_mapping = "gu", -- Undo for entire lines
			partial_mapping = "gcu", -- Undo for selected characters -- Note: dont use this line as gu can also handle partial undo
		})
		vim.keymap.set("v", "u", ":SelectUndoLine<CR>", {
			silent = true,
			noremap = true,
			desc = "Selective undo for entire lines",
		})
	end,
}
