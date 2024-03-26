local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local M = {
	ls.parser.parse_snippet({ trig = "log" }, "console.log($0)"),
	ls.parser.parse_snippet({ trig = "ter" }, "${1:cond} ? ${2:then} : ${3:else}"),

	ls.parser.parse_snippet({ trig = "af" }, "(${1:params}) => {\n\t$0\n}"),
	ls.parser.parse_snippet({ trig = "fn" }, "function ${1:name}(${2:params}) {\n\t$0\n}"),

	ls.parser.parse_snippet({ trig = "l" }, "let ${1:name} = ${3:assign}"),
	ls.parser.parse_snippet({ trig = "la" }, "let ${1:name} = await ${3:assign}"),

	ls.parser.parse_snippet({ trig = "c" }, "const ${1:name} = ${3:assign}"),
	ls.parser.parse_snippet({ trig = "ca" }, "const ${1:name} = await ${3:assign}"),
	ls.parser.parse_snippet({ trig = "cd" }, "const { ${1:name} } = ${3:assign}"),

	ls.parser.parse_snippet({ trig = "if" }, "if (${1:condition}) {\n\t${0}\n}"),
	ls.parser.parse_snippet({ trig = "ife" }, "if (${1:condition}) {\n\t${2}\n} else {\n\t${0}\n}"),
	ls.parser.parse_snippet(
		{ trig = "fi" },
		"for (let ${1:key} in ${2:source}) {\n\tif (${2:source}.hasOwnProperty(${1:key})) {\n\t\t${0}\n\t}\n}"
	),
	ls.parser.parse_snippet({ trig = "fo" }, "for (const ${1:key} of ${2:source}) {\n\t${0}\n}"),

	ls.parser.parse_snippet({ trig = "try" }, "try {\n\t${0}\n} catch (${1:err}) {\n\t${2}(${1:err})\n}"),

	ls.parser.parse_snippet({ trig = "desc" }, "describe(${1:name}, () => {\n\t${0}\n"),
	ls.parser.parse_snippet({ trig = "it" }, "it(${1:name}, async () => {\n\t${0}\n"),

	ls.parser.parse_snippet({ trig = "each" }, "${1:iterable}.forEach((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "map" }, "${1:iterable}.map((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "filter" }, "${1:iterable}.filter((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "find" }, "${1:iterable}.find((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "some" }, "${1:iterable}.some((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "every" }, "${1:iterable}.every((${2:item}) => {\n\t${0}\n})"),
	ls.parser.parse_snippet({ trig = "reduce" }, "${1:iterable}.reduce((${2:item}) => {\n\t${0}\n}${4:, initial})"),
}

return M
