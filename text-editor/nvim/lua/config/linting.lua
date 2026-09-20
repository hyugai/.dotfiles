local colors = require("ui.colors")
local signs = require("ui.signs")

local severity = vim.diagnostic.severity

-- Diagnostic colors
vim.api.nvim_set_hl(0, "DiagnosticError", {
	fg = colors.linter.Error,
})

vim.api.nvim_set_hl(0, "DiagnosticWarn", {
	fg = colors.linter.Warn,
})

vim.api.nvim_set_hl(0, "DiagnosticInfo", {
	fg = colors.linter.Info,
})

vim.api.nvim_set_hl(0, "DiagnosticHint", {
	fg = colors.linter.Hint,
})

-- Diagnostics
vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
		format = function(diagnostic)
			if diagnostic.source then
				return string.format("%s (%s)", diagnostic.message, diagnostic.source)
			end

			return diagnostic.message
		end,
	},

	underline = false,
	severity_sort = true,

	signs = {
		text = {
			[severity.ERROR] = signs.linter.Error,
			[severity.WARN] = signs.linter.Warn,
			[severity.INFO] = signs.linter.Info,
			[severity.HINT] = signs.linter.Hint,
		},
	},

	update_in_insert = false,
})

vim.opt.signcolumn = "yes:1"
