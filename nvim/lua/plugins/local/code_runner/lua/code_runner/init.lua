local sided_terminal = require("code_runner.sided_terminal")
local shell_cmds = require("code_runner.shell_cmds")

local M = {}

function M.setup()
	--namespace
	local ns_id = vim.api.nvim_create_namespace("CodeRunner")
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { fg = "#ff8800" })

	--user's command
	vim.api.nvim_create_user_command("RunCode", function(opts)
		shell_cmds.run(opts.args)
	end, { desc = "perform simple execution command(s) over current buffer inside floating terminal", nargs = "*" })

	--keymap
	vim.keymap.set({ "n", "t" }, "<leader>tt", function()
		sided_terminal:toggleTerminal()
	end, {
		desc = "`tt` stands for `Toggle Term`, open new instance of terminal if not available, if available, REOPEN if window was closed, HIDE if available and opened",
	})

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
