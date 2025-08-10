local sided_terminal = require("code_runner.sided_terminal")

local M = {}

function M.setup()
	--namespace
	local ns_id = vim.api.nvim_create_namespace("CodeRunner")
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { fg = "#ff8800" })

	--user's command
	vim.api.nvim_create_user_command("OpenSidedTerminal", function(args)
		sided_terminal:init()
	end, { desc = "Open a below sided terminal without an initial command", nargs = 0 })

	--keymap
	vim.keymap.set("t", "<C-h>", function()
		sided_terminal:hide()
	end, { buffer = sided_terminal.BUFFER.id })

	--autocmd
	vim.api.nvim_create_autocmd("WinResized", {
		buffer = sided_terminal.BUFFER.id,
		callback = function(args)
			sided_terminal:autoResize()
		end,
		desc = "Resize the sided window when editor's window is resized",
	})
end

return M
