return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = {
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "accept", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "show", "select_next", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		cmdline = {
			sources = { "cmdline" },
		},
		completion = {
			documentation = { auto_show = true },
			ghost_text = { enabled = false },
		},
		signature = { enabled = true },
	},
}
