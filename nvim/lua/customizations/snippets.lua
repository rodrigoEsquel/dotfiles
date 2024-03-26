local ls = require("luasnip")

ls.add_snippets("javascript", require("customizations.snippets-javascript"))
ls.add_snippets("typescript", require("customizations.snippets-typescript"))

require("luasnip").filetype_extend("typescript", { "javascript" })
