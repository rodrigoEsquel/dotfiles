function diagnostic(level)
	if (vim.diagnostic.count(0)[level] or 0) > 0 then
		return "●"
	else
		return ""
	end
end
local M = {}
function M.error_ind()
	return diagnostic(vim.diagnostic.severity.ERROR)
end
function M.warn_ind()
	return diagnostic(vim.diagnostic.severity.WARN)
end
function M.info_ind()
	return diagnostic(vim.diagnostic.severity.INFO)
end
function M.note_ind()
	return diagnostic(vim.diagnostic.severity.HINT)
end

return M
