local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#FF6C6B" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ECBE7B" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#51AFEF" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#98BE65" })

vim.cmd [[
  highlight! DiagnosticVirtualTextError guifg=#FF6C6B
]]


vim.diagnostic.config({
	virtual_text = {
		prefix = function(d)
			local severity = d.severity
			if severity == vim.diagnostic.severity.ERROR then
				return signs.Error
			elseif severity == vim.diagnostic.severity.WARN then
				return signs.Warn
			elseif severity == vim.diagnostic.severity.INFO then
				return signs.Info
			elseif severity == vim.diagnostic.severity.HINT then
				return signs.Hint
			end
		end,
		format = function(_)
			return ""
		end,
	},
	virtual_lines = {
		current_line = true,
		format = function(d)
			return string.format("[%s]: %s (%s)", vim.diagnostic.severity[d.severity], d.message, d.source or "unknown")
		end,
	},
	severity_sort = true,
	signs = false,
	update_in_insert = false,
})
