local ls = require("luasnip")

local M = {
	ls.parser.parse_snippet({ trig = "ct" }, "const ${1:name}: ${2:type} = ${3:assign}"),
	ls.parser.parse_snippet({ trig = "cat" }, "const ${1:name}: ${2:type} = await ${3:assign}"),
	ls.parser.parse_snippet({ trig = "lt" }, "let ${1:name}: ${2:type} = ${3:assign}"),
	ls.parser.parse_snippet({ trig = "lat" }, "let ${1:name}: ${2:type} = await ${3:assign}"),
	ls.parser.parse_snippet({ trig = "aft" }, "(${1:params}): ${2:type} => {\n\t$0\n}"),
	ls.parser.parse_snippet({ trig = "tr" }, "if ${1:[[ ${2:word} -eq ${3:word2} ]]}; then\n\t$4\nfi"),
}

return M
