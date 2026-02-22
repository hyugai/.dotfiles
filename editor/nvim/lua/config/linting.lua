--icons used for 'virtual_text'
local signs = {
	Error = "✘",
	Warn = "▲",
	Hint = "⚑",
	Info = "»",
}
--hex-code colors used for 'virtual_lines'
local colors = {
	Error = "#fb4934",
	Warn = "#fabd2f",
	Hint = "#6e7781",
	Info = "#0969da",
}

--update 'virtual_text' colors
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = colors.Error })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = colors.Warn })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = colors.Info })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = colors.Hint })

--update 'virtual_lines' colors (including the "tree" line and texts of it)
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.Error })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.Warn })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.Info })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.Hint })

--main
vim.diagnostic.config({
	--virtual_text = {
	--	prefix = function(d)
	--		local severity = d.severity
	--		if severity == vim.diagnostic.severity.ERROR then
	--			return signs.Error
	--		elseif severity == vim.diagnostic.severity.WARN then
	--			return signs.Warn
	--		elseif severity == vim.diagnostic.severity.INFO then
	--			return signs.Info
	--		elseif severity == vim.diagnostic.severity.HINT then
	--			return signs.Hint
	--		else
	--			return ""
	--		end
	--	end,
	--	format = function(_)
	--		return ""
	--	end,
	--},
	virtual_lines = {
		current_line = true,
		format = function(d)
			--return string.format("[%s]: %s (%s)", vim.diagnostic.severity[d.severity], d.message, d.source or "unknown")
			return string.format("%s", d.message)
		end,
	},
	underline = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = signs.Error,
			[vim.diagnostic.severity.WARN] = signs.Warn,
			[vim.diagnostic.severity.HINT] = signs.Hint,
			[vim.diagnostic.severity.INFO] = signs.Info,
		},
	},
	update_in_insert = false,
})
vim.opt.signcolumn = "yes:1" -- `signs`
