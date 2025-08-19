local M = {}
local toggle_float = require("switch.toggle_float")
local buffer = require("switch.buffer")

function M.setup(_)
	--#namespace
	local ns_id = vim.api.nvim_create_namespace("switch.nvim")
	vim.api.nvim_set_hl(ns_id, "FloatBorder", { fg = "#ff8800" })
	--#end_namespace

	--#user's_command
	vim.api.nvim_create_user_command("SwitchBuf", function(opts)
		buffer:toggle()
	end, {})
	--#end_user's_command

	--#keymap
	vim.keymap.set("n", "<leader>sb", "<CMD>SwitchBuf<CR>")
	vim.keymap.set("n", "q", function()
		toggle_float:terminate()
	end, { buffer = toggle_float.BUFFER.id_scratch })
	vim.keymap.set("n", "<CR>", function()
		buffer:switch()
	end, { buffer = toggle_float.BUFFER.id_scratch })
	--#end_keymap
end

return M
