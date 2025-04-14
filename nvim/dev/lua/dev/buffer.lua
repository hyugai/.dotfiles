local class = require("dev.utils.class")
local fn = require("dev.utils.fn")

local function lookup_active_bufs()
	local cwd = vim.fn.getcwd()
	local bufs = {
		all = vim.api.nvim_list_bufs(),
        valid = {}
	}
	for _, buf in ipairs(bufs.all) do
		local name = vim.api.nvim_buf_get_name(buf)
		if vim.uv.fs_stat(name) then
			local start_idx, _ = string.find(name, cwd)
			if start_idx == 1 then
				bufs.valid[string.gsub(name, cwd, ".")] = {
					is_hosted = false,
					id = buf,
				}
			end
		end
	end

	return bufs.valid
end

local function lookup_hosted_bufs() end

local function setup(opts)
	vim.api.nvim_create_user_command("SwitchBuf", function()
		local active_bufs = lookup_active_bufs()
		local bufs_names, _ = fn.unpack_dict(active_bufs)
		local menu = class.Menu:new(opts, bufs_names)

		local win = vim.api.nvim_open_win(menu.buf, true, menu.opts)
		menu:resize_autonomously()

		--keymaps
		vim.keymap.set("n", "q", ":q<CR>", { buffer = menu.buf })
	end, {})
end

local M = {
	setup = setup,
}

return M
