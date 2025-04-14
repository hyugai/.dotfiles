local switchers = {
	buffer = require("dev.buffer"),
}

local function setup(opts)
	switchers.buffer.setup(opts.buffer)

	--keymaps
	vim.keymap.set("n", "<leader>sb", ":SwitchBuf<CR>", { noremap = true })
end

local M = {
	setup = setup,
}

return M
