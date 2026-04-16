-- Custom snippets loaded via InsertEnter autocmd
-- TODO: migrate to blink.cmp/vim.snippet format if needed
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		local ok, ls = pcall(require, "luasnip")
		if not ok then
			return
		end

		ls.add_snippets("javascript", require("plugins.snippets.javascript"))
		ls.add_snippets("typescript", require("plugins.snippets.typescript"))
		ls.add_snippets("typescriptreact", require("plugins.snippets.typescript"))

		ls.filetype_extend("typescript", { "javascript" })
		ls.filetype_extend("javascriptreact", { "javascript" })
		ls.filetype_extend("typescriptreact", { "typescript" })
	end,
})

return {}
