local sided_terminal = require("code_runner.sided_terminal")
local shell_cmds = require("code_runner.shell_cmds")

local M = {}

function M.setup()
	--namespace
	local ns_id = vim.api.nvim_create_namespace("CodeRunner")
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { fg = "#ff8800" })

	--user's command
	vim.api.nvim_create_user_command("OpenSidedTerminal", function(opts)
		sided_terminal:init()
	end, { desc = "Open a below sided terminal without initial command(s)", nargs = 0 })

	vim.api.nvim_create_user_command("RunCode", function(opts)
		shell_cmds.run(opts.args)
	end, { desc = "Execute command(s) on the current buffer in a floating terminal", nargs = "*" })

	--keymap
	vim.keymap.set("t", "<C-h>", function()
		sided_terminal:hide()
	end, { buffer = sided_terminal.BUFFER.id })

	--autocmd
	vim.api.nvim_create_autocmd("WinResized", {
		buffer = sided_terminal.BUFFER.id,
		callback = function(opts)
			if sided_terminal.BUFFER.id then --?: this will make sure, the function will be only triggered by this plugin
				sided_terminal:autoResize()
			end
		end,
		desc = "Resize the sided window when editor's window is resized",
	})
end

return M
