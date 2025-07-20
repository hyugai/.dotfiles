local switch_buf = require("switcher.switch_buf")
local switch_venv = require("switcher.switch_venv")

local M = {}

function M.setup(_)
	--SwitchBuf
	vim.api.nvim_create_user_command("SwitchBuf", function()
		switch_buf:init()
	end, { nargs = 0 })
	vim.keymap.set("n", "<leader>sb", "<CMD>SwitchBuf<CR>", { noremap = true })

	--Switch Python Virtual Environment
	vim.api.nvim_create_user_command("SwitchPythonVenv", function()
		switch_venv:init()
	end, { nargs = 0 })
	vim.keymap.set("n", "<leader>sp", "<CMD>SwitchPythonVenv<CR>", { noremap = true })
end

return M
