local diag = require("kanagawa.colors").setup({ theme = "wave" }).theme.diag

-- local DiagnosticColor = {
-- 	DiagnosticUnderlineError = {
-- 		sp = diag.error,
-- 		underline = true,
-- 	},
-- 	DiagnosticUnderlineWarn = {
-- 		sp = diag.warning,
-- 		underline = true,
-- 	},
-- 	DiagnosticUnderlineInfo = {
-- 		sp = diag.info,
-- 		underline = true,
-- 	},
-- 	DiagnosticUnderlineHint = {
-- 		sp = diag.hint,
-- 		underline = true,
-- 	},
-- 	DiagnosticUnderlineOk = {
-- 		sp = diag.ok,
-- 		underline = true,
-- 	},
-- }
--
-- for hl, col in pairs(DiagnosticColor) do
-- 	vim.api.nvim_set_hl(0, hl, col)
-- end

vim.cmd("highlight! DiagnosticUnderlineError cterm=underline,underline guisp=" .. diag.error)
vim.cmd("highlight! DiagnosticUnderlineWarn cterm=underline,underline guisp=" .. diag.warning)
vim.cmd("highlight! DiagnosticUnderlineInfo cterm=underline,underline guisp=" .. diag.info)
vim.cmd("highlight! DiagnosticUnderlineHint cterm=underline,underline guisp=" .. diag.hint)
vim.cmd("highlight! DiagnosticUnderlineOk cterm=underline,underline guisp=" .. diag.ok)
