local ls = require("luasnip")

ls.add_snippets("javascript", require("customizations.snippets-javascript"))
ls.add_snippets("typescript", require("customizations.snippets-typescript"))
ls.add_snippets("typescriptreact", require("customizations.snippets-typescript"))

require("luasnip").filetype_extend("typescript", { "javascript" })
require("luasnip").filetype_extend("javascriptreact", { "javascript" })
require("luasnip").filetype_extend("typescriptreact", { "typescript" })
