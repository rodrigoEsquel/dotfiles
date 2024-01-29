return {
	-- Add persistencie to undo files
	"kevinhwang91/nvim-fundo",
	dependencies = "kevinhwang91/promise-async",
	build = function()
		require("fundo").install()
	end,
	opts = {},
}
