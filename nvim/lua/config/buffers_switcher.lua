local function print_list(t)
	for _, v in ipairs(t) do
		print(v)
	end
end

local function get_valid_active_bufs()
	local bufnrs = vim.api.nvim_list_bufs()
	local cwd = vim.fn.getcwd()
	local res = {}
	for _, v in ipairs(bufnrs) do
		local name = vim.api.nvim_buf_get_name(v)
		if vim.uv.fs_stat(name) then
			name = string.gsub(name, cwd, ".")
			table.insert(res, name)
		end
	end

	return res
end

local function _get_win_dimensions()
	local width = { start = ((1 - 0.5) / 2) * vim.o.columns, magnitude = math.ceil(vim.o.columns * 0.5) }
	local height = { start = ((1 - 0.5) / 2) * vim.o.lines, magnitude = math.ceil(vim.o.lines * 0.5) }

	return width, height
end
local function open()
	local active_files = get_valid_active_bufs()

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, active_files)
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
	vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
	vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })

	local width, height = _get_win_dimensions()
	vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width.magnitude,
		height = height.magnitude,
		col = width.start,
		row = height.start,
		style = "minimal",
		border = "rounded",
	})
end

vim.api.nvim_create_user_command("SwitchBuf", open, { desc = "Switch to another active file" })
vim.keymap.set("n", "<leader>sb", ":SwitchBuf<CR>", {})
vim.keymap.set("n", "<CR>", function() end, { desc = "Attach selected buffer to the last used window" })
--vim.api.nvim_create_autocmd("VimResized", {
--	callback = function()
--        print("editor is resized!")
--		local width, height = _get_win_dimensions()
--		vim.api.nvim_win_set_config(0, {
--			width = width.magnitude,
--			height = height.magnitude,
--			col = width.start,
--			row = height.start,
--		})
--	end,
--})
--autoclose when cursor is in another window
