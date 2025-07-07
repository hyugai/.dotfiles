local switch_buf = require("switcher.switch_buf")
local M = {}

function M.setup(_)
	--SwitchBuf
	vim.api.nvim_create_user_command("SwitchBuf", function()
		switch_buf:init()
	end, { nargs = 0 })
	vim.keymap.set("n", "<leader>sb", "<CMD>SwitchBuf<CR>", { noremap = true })
end

return M
