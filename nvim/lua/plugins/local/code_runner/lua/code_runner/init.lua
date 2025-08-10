local sided_terminal = require("code_runner.sided_terminal")

local M = {}

function M.setup(_)
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
end

return M
